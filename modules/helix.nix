{
  flake.nixosModules.helix = {pkgs, ...}: {
    environment.variables.EDITOR = "hx";

    environment.systemPackages = with pkgs; [
      helix # duh

      # The LSPs for different languages
      # These should be runtime depedencys of helix
      # I am (hopefully) going to change that later
      nixd
      nil
      tinymist
      rust-analyzer
      ty
      jdt-language-server
      superhtml
      vscode-json-languageserver
      marksman
      taplo
      hyprls
      just-lsp
      texlab
      bibtex-tidy
      bash-language-server
    ];
  };
}
