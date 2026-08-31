{ config, pkgs, ... }:

{
  # Fingerprint reader (Goodix match-on-chip, supported by libfprint).
  # Enroll with `fprintd-enroll` after rebuild. Sudo picks it up via PAM
  # automatically; hyprlock uses its native fprintd integration instead
  # (see home-manager/modules/hyprland.nix), so keep PAM out of its way.
  services.fprintd.enable = true;
  security.pam.services.hyprlock.fprintAuth = false;

  # The Goodix reader (27c6:6594) drops off the USB bus under aggressive
  # power management: autosuspend causes "Cannot run while suspended"
  # verify errors, and repeated suspend/resume cycles eventually leave it
  # un-enumerated until a full power cycle. Pin its runtime PM on and keep
  # TLP's hands off it.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="27c6", ATTR{idProduct}=="6594", ATTR{power/control}="on", ATTR{power/autosuspend}="-1"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", ATTR{power/control}="auto"
  '';

  # The discrete NVIDIA RTX A500 caused black screens on lid-open/resume and
  # we run no GPU workloads, so render on the Intel iGPU only. Blacklist both
  # the proprietary and nouveau drivers; the udev rule above then lets PCI
  # runtime PM drop the unbound dGPU into D3cold for the battery win.
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];

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

      # Keep TLP from re-enabling autosuspend on the Goodix fingerprint
      # reader (see the udev rule above).
      USB_DENYLIST = "27c6:6594";
    };
  };

  # Lid close falls through to logind's default HandleLidSwitch = suspend;
  # no hibernation.

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
