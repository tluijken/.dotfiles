{ config, pkgs, ... }:

{

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  # Add user to libvirtd group
  users.users.thomas.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
  ];

  # Manage the virtualisation services
  virtualisation = {
      docker = {
          enable = true;

          # rootless = {
          #     enable = true;
          #     setSocketVariable = true;
          # };
      };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  services.flatpak.enable = true;
}
