{ config, pkgs, ... }:

{

    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware.graphics.enable = true;   # was hardware.opengl.enable before NixOS 24.11
    
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;          # Turing is supported by the open modules; flip to false if you hit trouble
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # PRIME bus IDs are machine-specific; set hardware.nvidia.prime
      # in /etc/nixos/local.nix on hybrid-graphics machines.
    };
}
