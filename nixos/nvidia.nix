# PARKED: this module is intentionally not imported. The discrete RTX A500
# is disabled and we render on the Intel iGPU only (see nixos/laptop.nix).
# To re-enable hybrid graphics: add this file to the imports in
# nixos/configuration.nix, drop the dGPU blacklist in laptop.nix, and restore
# the hardware.nvidia.prime bus IDs (intel PCI:0:2:0, nvidia PCI:3:0:0).
{ config, pkgs, ... }:

{

    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware.graphics.enable = true;   # was hardware.opengl.enable before NixOS 24.11
    
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;         # proprietary modules; most battle-tested for suspend/resume
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # PRIME bus IDs are machine-specific; set hardware.nvidia.prime
      # in /etc/nixos/local.nix on hybrid-graphics machines.
    };
}
