{ pkgs, ... }:
let
  mkGDriveService = { name, description, teamDriveId ? null }: {
    Unit = {
      Description = "Google Drive – ${description}";
      # No network-online.target: it doesn't exist in the user manager, so it
      # can't be waited on; the Restart loop below rides out early failures.
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive/${name}";
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive: %h/GoogleDrive/${name}"
        + " --vfs-cache-mode full --vfs-cache-max-size 1G"
        + (if teamDriveId != null then " --drive-team-drive ${teamDriveId}" else "");
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/GoogleDrive/${name}";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
in
{
  systemd.user.services.google-drive-personal = mkGDriveService {
    name = "Personal";
    description = "Personal";
  };

  systemd.user.services.google-drive-baseflow = mkGDriveService {
    name = "Baseflow";
    description = "Baseflow";
    teamDriveId = "0AF8eNvwTF3jfUk9PVA";
  };

  systemd.user.services.google-drive-baseflow-products = mkGDriveService {
    name = "Baseflow-Products";
    description = "Baseflow - Products";
    teamDriveId = "0AErQVe4r26iHUk9PVA";
  };

  systemd.user.services.google-drive-industrial-management = mkGDriveService {
    name = "Industrial-Management";
    description = "Industrial - Management";
    teamDriveId = "0AO31SPXLgrBgUk9PVA";
  };
}
