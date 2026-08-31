{ pkgs-unstable, ... }:

{
  programs.claude-code = {
    enable = true;
    # Claude Code releases weekly; the 26.05 channel lags too far behind.
    package = pkgs-unstable.claude-code;
    agents = {
      nix-pro = ./claude-agents/nix-pro.md;
    };
    skills = {
      nixos = ./claude-skills/nixos;
    };
    mcpServers = {
      nixos = {
        command = "${pkgs-unstable.mcp-nixos}/bin/mcp-nixos";
      };
      context7 = {
        command = "${pkgs-unstable.context7-mcp}/bin/context7-mcp";
      };
      sequential-thinking = {
        command = "${pkgs-unstable.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking";
      };
    };
  };
}
