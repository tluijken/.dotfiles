# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./virtualization.nix
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ee3b61bb-a03e-4153-848f-ea5d40727985".device = "/dev/disk/by-uuid/ee3b61bb-a03e-4153-848f-ea5d40727985";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
    # Optional: enable IPv6 forwarding too
    "net.ipv6.conf.all.forwarding" = "1";
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.extraHosts =
  ''
    127.0.0.1 keycloak
    172.18.255.200 dev.test
  '';
  networking.nameservers = [ "86.54.11.13" "1.1.1.1" "9.9.9.9" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
        General = {
            ControllerMode = "dual";
            Experimental = true;
        };
    };
  };

  # to ensure the D-Bus services are actually installed and known to the system
  xdg.portal.enable = true;

  # .enable = true; # enables support for Bluetooth
  # hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomas = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Thomas";
    ignoreShellProgramCheck = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout"];
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
     home-manager
     cifs-utils
     keychain
     mako
     cups
  ];

  services.gvfs.enable = true;
  environment.variables.editor = "neovim";
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
      criticalPowerAction = "Hibernate";
  };

  services.tailscale.enable = true;

  programs.sway = {
     enable = true;
     wrapperFeatures.gtk = true;
  };

  programs.hyprland.enable = true; # enable Hyprland

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
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
  # Enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
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
    checkReversePath = false; # Important for tailscale routing
    allowedUDPPorts = [ 41641 53 67 ]; # Tailscale and virtmanager
    allowedTCPPorts = [  53 ]; # Virt-manager
    trustedInterfaces = [ "tailscale0" "virbr0" "docker0" ]; # Trust Tailscale and virtual bridge interfaces
  };

  networking.nat.enable = false; # NAT handled by tailscale itself

  services.fwupd.enable = true;

  # Nodig om D-Bus services zoals die van KeePassXC vindbaar te maken
  services.dbus.enable = true;

  # Soms helpt dit om libraries voor certificaten (GCR) correct te laden
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
