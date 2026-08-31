{ pkgs, ... }:
{
  home.packages = [ pkgs.sshfs ];

  systemd.user.services.cloudbox = {
    Unit = {
      Description = "Cloudbox home directory (SSHFS over Tailscale)";
      # No network-online.target: it doesn't exist in the user manager, so it
      # can't be waited on; the Restart loop below rides out early failures.
    };
    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Cloudbox";
      ExecStart = "${pkgs.sshfs}/bin/sshfs -f thomas@cloudbox:/home/thomas %h/Cloudbox"
        + " -o IdentityFile=%h/.ssh/cloudbox"
        + " -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"
        + " -o StrictHostKeyChecking=accept-new"
        + " -o idmap=user";
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/Cloudbox";
      ExecStopPost = "-${pkgs.fuse3}/bin/fusermount3 -uz %h/Cloudbox";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
