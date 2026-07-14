{ pkgs, ... }:
{
  home.packages = [ pkgs.rclone ];

  systemd.user.services.proton-drive = {
    Unit = {
      Description = "Proton Drive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/ProtonDrive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount protondrive: %h/ProtonDrive --vfs-cache-mode full --vfs-cache-max-size 1G";
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/ProtonDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
