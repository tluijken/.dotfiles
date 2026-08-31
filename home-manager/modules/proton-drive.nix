{ pkgs, ... }:
{
  home.packages = [ pkgs.rclone ];

  systemd.user.services.proton-drive = {
    Unit = {
      Description = "Proton Drive";
      # No network-online.target: it doesn't exist in the user manager, so it
      # can't be waited on; the Restart loop below rides out early failures.
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
