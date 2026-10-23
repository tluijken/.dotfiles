set -euo pipefail

NC_HOST="${NC_HOST:-https://cloud.luijken.dev}"
NC_USER="${NC_USER:-admin}"
NC_CAL="${NC_CAL:-scheiding}"
NC_PASS_FILE="${NC_PASS_FILE:-$HOME/.config/sops-nix/secrets/nextcloud-caldav}"

die() {
  printf 'nc-cal: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
nc-cal event --start <tijd> --end <tijd> --summary <tekst> [--desc <tekst>] [--alarm 1d] [--cal <agenda>]
nc-cal todo  --due <tijd> --summary <tekst> [--desc <tekst>] [--alarm 3d] [--cal <agenda>]
nc-cal list  [--from <datum>] [--to <datum>] [--cal <agenda>]
nc-cal done  --uid <uid> [--cal <agenda>]
nc-cal rm    --uid <uid> [--cal <agenda>]

Tijden gaan door date(1), dus "2026-12-17T09:00", "2026-12-01" en
"next friday 14:00" werken allemaal. Een --due zonder tijd wordt een
dagtaak. Alarm is 30m, 2h of 1d voor aanvang.
EOF
}

# curl krijgt de credentials via een configbestand in plaats van --user, omdat
# argumenten op deze machine voor elk ander proces in /proc zichtbaar zijn.
#
# Dit gebeurt eenmalig in de hoofdshell en niet lui in nc_curl: die draait in
# pipelines, dus in een subshell, en daar zou elke aanroep opnieuw inlezen. Dat
# kost een tempfile per aanroep en loopt stuk op een NC_PASS_FILE die maar een
# keer te lezen is, zoals een process substitution.
curl_cfg=""
cleanup() { [ -n "$curl_cfg" ] && rm -f "$curl_cfg"; return 0; }
trap cleanup EXIT

init_auth() {
  [ -r "$NC_PASS_FILE" ] || die "app-wachtwoord niet leesbaar op $NC_PASS_FILE"
  curl_cfg="$(umask 077 && mktemp)"
  printf 'user = "%s:%s"\n' "$NC_USER" "$(cat "$NC_PASS_FILE")" >"$curl_cfg"
}

nc_curl() {
  curl --silent --show-error --fail-with-body --config "$curl_cfg" "$@"
}

cal_url() { printf '%s/remote.php/dav/calendars/%s/%s' "$NC_HOST" "$NC_USER" "$NC_CAL"; }

# RFC 5545 kent geen escape voor een harde newline in een property, dus die
# wordt \n in de waarde zelf.
ics_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/;/\\;/g' -e 's/,/\\,/g' | awk 'BEGIN { ORS = "" } NR > 1 { print "\\n" } { print }'
}

# Niet date -u -d "<tijd>": -u zet de zone voor de hele aanroep, dus dan wordt
# de invoer ook als UTC gelezen en levert 09:00 CET een uur te late 09:00Z op.
# Via epoch gaat het parsen lokaal en het formatteren in UTC.
to_utc() {
  local epoch
  epoch="$(date -d "$1" +%s 2>/dev/null)" || die "onbegrijpelijke tijd: $1"
  date -u -d "@$epoch" +%Y%m%dT%H%M%SZ
}
to_date() { date -d "$1" +%Y%m%d 2>/dev/null || die "onbegrijpelijke datum: $1"; }

# Een losse datum zonder tijd moet een DATE blijven; date(1) vult er anders
# middernacht bij en dan wordt het een afspraak van nul minuten om 00:00.
has_time() { [[ $1 == *[T:]* ]]; }

alarm_trigger() {
  local n="${1%[mhd]}" u="${1##*[0-9]}"
  [[ $n =~ ^[0-9]+$ ]] || die "onbegrijpelijk alarm: $1 (gebruik 30m, 2h of 1d)"
  case "$u" in
    m) printf -- '-PT%sM' "$n" ;;
    h) printf -- '-PT%sH' "$n" ;;
    d) printf -- '-P%sD' "$n" ;;
    *) die "onbekende alarm-eenheid in '$1' (gebruik 30m, 2h of 1d)" ;;
  esac
}

emit() { printf '%s\r\n' "$*"; }

put_ics() {
  local uid="$1" body="$2"
  printf '%s\n' "$body" | nc_curl --request PUT \
    --header 'Content-Type: text/calendar; charset=utf-8' \
    --data-binary @- "$(cal_url)/$uid.ics" >/dev/null
  printf '%s\n' "$uid"
}

cmd_event() {
  local start="" end="" summary="" desc="" alarm="" uid trigger body
  while [ $# -gt 0 ]; do
    case "$1" in
      --start) start="$2"; shift 2 ;;
      --end) end="$2"; shift 2 ;;
      --summary) summary="$2"; shift 2 ;;
      --desc) desc="$2"; shift 2 ;;
      --alarm) alarm="$2"; shift 2 ;;
      --cal) NC_CAL="$2"; shift 2 ;;
      *) die "onbekende optie: $1" ;;
    esac
  done
  [ -n "$start" ] || die "--start is verplicht"
  [ -n "$summary" ] || die "--summary is verplicht"
  [ -n "$end" ] || end="$start + 1 hour"

  uid="$(uuidgen)"
  body="$(
    emit 'BEGIN:VCALENDAR'
    emit 'VERSION:2.0'
    emit 'PRODID:-//nc-cal//NONSGML v1.0//EN'
    emit 'BEGIN:VEVENT'
    emit "UID:$uid"
    emit "DTSTAMP:$(date -u +%Y%m%dT%H%M%SZ)"
    if has_time "$start"; then
      emit "DTSTART:$(to_utc "$start")"
      emit "DTEND:$(to_utc "$end")"
    else
      emit "DTSTART;VALUE=DATE:$(to_date "$start")"
      emit "DTEND;VALUE=DATE:$(to_date "$start + 1 day")"
    fi
    emit "SUMMARY:$(ics_escape "$summary")"
    [ -n "$desc" ] && emit "DESCRIPTION:$(ics_escape "$desc")"
    if [ -n "$alarm" ]; then
      trigger="$(alarm_trigger "$alarm")"
      emit 'BEGIN:VALARM'
      emit 'ACTION:DISPLAY'
      emit "TRIGGER:$trigger"
      emit "DESCRIPTION:$(ics_escape "$summary")"
      emit 'END:VALARM'
    fi
    emit 'END:VEVENT'
    emit 'END:VCALENDAR'
  )"
  put_ics "$uid" "$body"
}

cmd_todo() {
  local due="" summary="" desc="" alarm="" uid trigger body
  while [ $# -gt 0 ]; do
    case "$1" in
      --due) due="$2"; shift 2 ;;
      --summary) summary="$2"; shift 2 ;;
      --desc) desc="$2"; shift 2 ;;
      --alarm) alarm="$2"; shift 2 ;;
      --cal) NC_CAL="$2"; shift 2 ;;
      *) die "onbekende optie: $1" ;;
    esac
  done
  [ -n "$summary" ] || die "--summary is verplicht"

  uid="$(uuidgen)"
  body="$(
    emit 'BEGIN:VCALENDAR'
    emit 'VERSION:2.0'
    emit 'PRODID:-//nc-cal//NONSGML v1.0//EN'
    emit 'BEGIN:VTODO'
    emit "UID:$uid"
    emit "DTSTAMP:$(date -u +%Y%m%dT%H%M%SZ)"
    emit 'STATUS:NEEDS-ACTION'
    if [ -n "$due" ]; then
      if has_time "$due"; then
        emit "DUE:$(to_utc "$due")"
      else
        emit "DUE;VALUE=DATE:$(to_date "$due")"
      fi
    fi
    emit "SUMMARY:$(ics_escape "$summary")"
    [ -n "$desc" ] && emit "DESCRIPTION:$(ics_escape "$desc")"
    # Een VALARM in een VTODO hangt aan DUE in plaats van DTSTART, dus zonder
    # --due is er niets om op te triggeren.
    if [ -n "$alarm" ] && [ -n "$due" ]; then
      trigger="$(alarm_trigger "$alarm")"
      emit 'BEGIN:VALARM'
      emit 'ACTION:DISPLAY'
      emit "TRIGGER;RELATED=END:$trigger"
      emit "DESCRIPTION:$(ics_escape "$summary")"
      emit 'END:VALARM'
    fi
    emit 'END:VTODO'
    emit 'END:VCALENDAR'
  )"
  put_ics "$uid" "$body"
}

cmd_list() {
  local from="" to="" filter report
  while [ $# -gt 0 ]; do
    case "$1" in
      --from) from="$2"; shift 2 ;;
      --to) to="$2"; shift 2 ;;
      --cal) NC_CAL="$2"; shift 2 ;;
      *) die "onbekende optie: $1" ;;
    esac
  done

  if [ -n "$from" ] || [ -n "$to" ]; then
    filter="<c:time-range"
    [ -n "$from" ] && filter="$filter start=\"$(to_utc "${from}T00:00")\""
    [ -n "$to" ] && filter="$filter end=\"$(to_utc "${to}T23:59")\""
    filter="$filter/>"
  else
    filter=""
  fi

  report="<?xml version=\"1.0\" encoding=\"utf-8\"?>
<c:calendar-query xmlns:d=\"DAV:\" xmlns:c=\"urn:ietf:params:xml:ns:caldav\">
  <d:prop><c:calendar-data/></d:prop>
  <c:filter>
    <c:comp-filter name=\"VCALENDAR\">
      <c:comp-filter name=\"VEVENT\">$filter</c:comp-filter>
    </c:comp-filter>
  </c:filter>
</c:calendar-query>"

  # De VTODO-tak moet apart, want twee comp-filters naast elkaar binnen
  # VCALENDAR zijn een AND en leveren dus altijd niets op.
  {
    printf '%s' "$report" | nc_curl --request REPORT --header 'Depth: 1' \
      --header 'Content-Type: application/xml; charset=utf-8' --data-binary @- "$(cal_url)/"
    printf '%s' "${report//VEVENT/VTODO}" | nc_curl --request REPORT --header 'Depth: 1' \
      --header 'Content-Type: application/xml; charset=utf-8' --data-binary @- "$(cal_url)/"
  } | format_entries
}

# Properties mogen over regels gevouwen worden; een vervolgregel begint met een
# spatie of tab en moet eerst weer aangeplakt worden voor er iets te lezen valt.
format_entries() {
  tr -d '\r' | sed -e ':a' -e '$!N' -e 's/\n[ \t]//' -e 'ta' -e 'P' -e 'D' | awk '
    /^(BEGIN:VEVENT|BEGIN:VTODO)$/ { kind = ($0 == "BEGIN:VEVENT") ? "event" : "todo"; uid = when = sum = ""; done = 0 }
    /^UID:/ { uid = substr($0, 5) }
    /^DTSTART/ { split($0, p, ":"); when = p[2] }
    /^DUE/ { split($0, p, ":"); when = p[2] }
    /^STATUS:COMPLETED$/ { done = 1 }
    /^SUMMARY:/ { sum = substr($0, 9) }
    /^(END:VEVENT|END:VTODO)$/ { if (uid != "") printf "%-38s %-17s %-6s %s\n", uid, when, (done ? "done" : kind), sum }
  ' | sort -k2
}

# Afvinken gaat via de bestaande .ics in plaats van een nieuwe op te bouwen,
# zodat omschrijving, DUE en alarm blijven staan zoals ze waren.
cmd_done() {
  local uid="" stamp body
  while [ $# -gt 0 ]; do
    case "$1" in
      --uid) uid="$2"; shift 2 ;;
      --cal) NC_CAL="$2"; shift 2 ;;
      *) die "onbekende optie: $1" ;;
    esac
  done
  [ -n "$uid" ] || die "--uid is verplicht"

  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  body="$(
    nc_curl "$(cal_url)/$uid.ics" | tr -d '\r' | awk -v s="$stamp" '
      function mark() { print "STATUS:COMPLETED"; print "COMPLETED:" s; print "PERCENT-COMPLETE:100"; seen = 1 }
      /^STATUS:/ { mark(); next }
      /^(COMPLETED|PERCENT-COMPLETE):/ { next }
      /^END:VTODO$/ && !seen { mark() }
      { print }
    ' | sed 's/$/\r/'
  )"
  printf '%s\n' "$body" | nc_curl --request PUT \
    --header 'Content-Type: text/calendar; charset=utf-8' \
    --data-binary @- "$(cal_url)/$uid.ics" >/dev/null
  printf 'afgevinkt: %s\n' "$uid"
}

cmd_rm() {
  local uid=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --uid) uid="$2"; shift 2 ;;
      --cal) NC_CAL="$2"; shift 2 ;;
      *) die "onbekende optie: $1" ;;
    esac
  done
  [ -n "$uid" ] || die "--uid is verplicht"
  nc_curl --request DELETE "$(cal_url)/$uid.ics" >/dev/null
  printf 'verwijderd: %s\n' "$uid"
}

[ $# -gt 0 ] || { usage; exit 1; }
sub="$1"
shift
case "$sub" in
  event) init_auth && cmd_event "$@" ;;
  todo) init_auth && cmd_todo "$@" ;;
  list) init_auth && cmd_list "$@" ;;
  done) init_auth && cmd_done "$@" ;;
  rm) init_auth && cmd_rm "$@" ;;
  -h | --help | help) usage ;;
  *) die "onbekend subcommando: $sub" ;;
esac
