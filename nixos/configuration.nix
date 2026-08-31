# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ ./virtualization.nix
      ./audio.nix
      ./laptop.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  networking.extraHosts =
  ''
    127.0.0.1 keycloak
    172.18.255.200 dev.test
  '';
  # systemd-resolved gives split DNS: tailscale routes *.ts.net to MagicDNS
  # (100.100.100.100) while everything else uses these resolvers. Without it,
  # glibc reads resolv.conf flat, only tries the first 3 nameservers, and
  # MagicDNS names never resolve.
  services.resolved.enable = true;
  networking.nameservers = [ "86.54.11.13" "1.1.1.1" "9.9.9.9" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Run builds at low CPU/IO priority so rebuilds don't lag the desktop.
  nix.daemonCPUSchedPolicy = "batch";
  nix.daemonIOSchedClass = "idle";

  nix.settings.substituters = [ "https://nix-community.cachix.org" ];
  nix.settings.trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

  # Reclaim store space automatically
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;      # needed for BLE features on many mice
        FastConnectable = true;
        Privacy = "device";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # to ensure the D-Bus services are actually installed and known to the system
  # programs.hyprland already ships xdg-desktop-portal-hyprland; gtk covers the
  # interfaces (FileChooser, Settings, OpenURI) hyprland doesn't implement.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };

  # .enable = true; # enables support for Bluetooth
  # hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomas = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Thomas";
    ignoreShellProgramCheck = true;
    extraGroups = [ "networkmanager" "wheel" "dialout"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     neovim
     curl
     grim
     slurp
     wl-clipboard
     #firefox
     devbox
     gcc
     cifs-utils
     keychain
     cups
     system-config-printer
  ];

  services.gvfs.enable = true;
  environment.variables.EDITOR = "nvim";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # Used to fix resolving paths such as /bin/bash and more
  services.envfs.enable = true;

  # List services that you want to enable:
  services.upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 4;
      criticalPowerAction = "PowerOff";
  };

  services.tailscale.enable = true;
  # Sets loose rp_filter and IP forwarding, replacing the manual sysctl and
  # firewall.checkReversePath workarounds.
  services.tailscale.useRoutingFeatures = "both";

  services.syncthing = {
      enable = true;
      user = "thomas";
      dataDir = "/home/thomas";
      configDir = "/home/thomas/.config/syncthing";
      # No openDefaultPorts: all peers are on the tailnet and tailscale0 is a
      # trusted interface, so nothing needs exposing on untrusted networks.
  };

  programs.hyprland.enable = true; # enable Hyprland

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  security.pam.services.hyprlock = {};
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };
  services.pipewire.extraConfig.pipewire."70-custom" = {
    "context.properties" = {
      "default.clock.rate" = 44100;
      "default.clock.allowed-rates" = [ 44100 48000 ];
      "default.clock.quantum" = 512;
      "default.clock.min-quantum" = 256;
      "default.clock.max-quantum" = 1024;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # HP driver bundle as a fallback for models that are not fully driverless,
  # and for the hp-setup wizard. Modern HP printers print driverless via IPP.
  services.printing.drivers = [ pkgs.hplip ];
  # Enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
 services.gnome.gnome-keyring.enable = true;
 # security.pam.services.lightdm.enableGnomeKeyring = true;
 # programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    enable = true; # or false, if you're managing it manually
    # libvirt's dnsmasq (DNS/DHCP) is reachable on virbr0, which is already
    # a trusted interface, so 53 doesn't need opening on all interfaces.
    allowedUDPPorts = [ config.services.tailscale.port 67 ]; # Tailscale, libvirt DHCP
    allowedTCPPorts = [ ];
    trustedInterfaces = [ "tailscale0" "virbr0" ]; # Trust Tailscale and libvirt's bridge
  };

  networking.nat.enable = false; # NAT handled by tailscale itself

  services.fwupd.enable = true;

  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=50M
  '';

  # Periodic SSD TRIM
  services.fstrim.enable = true;

  # Skip access-time writes on reads
  fileSystems."/".options = [ "noatime" ];

  # Compressed in-RAM swap.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Nodig om D-Bus services zoals die van KeePassXC vindbaar te maken
  services.dbus.enable = true;

  # Soms helpt dit om libraries voor certificaten (GCR) correct te laden
  programs.dconf.enable = true;

  # system.stateVersion is machine-specific (the release the machine was
  # first installed with) and is set in /etc/nixos/local.nix.

}
