{ ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.bambulab.BambuStudio"
    ];
  };
}
