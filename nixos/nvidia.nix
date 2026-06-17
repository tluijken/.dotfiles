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
    
      prime = {
        intelBusId  = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
    
        # Pick ONE of these:
        sync.enable = true;
        # offload = { enable = true; enableOffloadCmd = true; };
      };
    };
}
