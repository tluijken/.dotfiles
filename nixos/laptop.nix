{ config, pkgs, ... }:

{
  # Fingerprint reader (Goodix match-on-chip, supported by libfprint).
  # Enroll with `fprintd-enroll` after rebuild. Sudo picks it up via PAM
  # automatically; hyprlock uses its native fprintd integration instead
  # (see home-manager/modules/hyprland.nix), so keep PAM out of its way.
  services.fprintd.enable = true;
  security.pam.services.hyprlock.fprintAuth = false;

  # No thermald: ThinkPads expose Lenovo's DYTC firmware thermal
  # management and thermald refuses to run alongside it. TLP steers
  # it via PLATFORM_PROFILE below instead.

  # TLP for battery life; conflicts with power-profiles-daemon.
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # Battery longevity: hold charge between 75–80% while on AC.
      # Run `tlp fullcharge` before travel to top up to 100% once.
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # DYTC platform profile (firmware thermal/perf engine)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # TLP's default (on) overrides the nvidia udev rule and keeps the
      # dGPU powered on AC, defeating RTD3. auto is also the BAT default.
      RUNTIME_PM_ON_AC = "auto";
    };
  };

  # This platform only supports s2idle (no S3 deep sleep), which drains
  # the battery noticeably overnight. On lid close, suspend first, then
  # transition to hibernate after 45 min. Requires boot.resumeDevice,
  # which is machine-specific and set in /etc/nixos/local.nix.
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  systemd.sleep.settings.Sleep.HibernateDelaySec = "45min";

  hardware.cpu.intel.updateMicrocode = true;

  # sched-ext scheduler tuned for interactivity; helps desktop latency
  # under load on hybrid P/E-core CPUs.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # Hardware video decode/encode on the Iris Xe iGPU; without this,
  # browser video and calls decode on the CPU.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API for Gen12+ (Iris Xe)
      vpl-gpu-rt         # QuickSync encode (OBS, ffmpeg)
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
}
