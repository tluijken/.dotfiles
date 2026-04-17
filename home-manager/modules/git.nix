{ config, pkgs, ... }:

let
  # Add the tool you want to use here
  myMergeTool = pkgs.kdiff3;
in
{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/github.com.pub";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Thomas Luijken";
        email = "thomas@luijken.dev";
      };
      merge.tool = "kdiff3";
      diff.tool = "kdiff3";
      mergetool.kdiff3 = {
        cmd = "${myMergeTool}/bin/kdiff3 $BASE $LOCAL $REMOTE -o $MERGED";
        trustExitCode = true;
      };
      mergetool.keepBackup = false;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";  # needed for verification
    };
  };
}
