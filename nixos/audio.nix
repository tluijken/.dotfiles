{ ... }:
{
  # Bluetooth audio — enable high-quality codecs and headset roles
  services.pipewire.wireplumber.extraConfig."51-bluetooth" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq"  = true;
      "bluez5.enable-msbc"    = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.headset-roles"  = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      "bluez5.codecs"         = [ "sbc" "sbc_xq" "aac" "ldac" "aptx" "aptx_hd" ];
    };
  };
}
