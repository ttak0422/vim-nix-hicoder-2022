{ config, pkgs, ... }:
let inherit (builtins) getEnv;
in {
  home = {
    username = "ttak0422";
    homeDirectory = "/home/ttak0422";
    stateVersion = "22.11";
  };
  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      {
        plugin = kanagawa-nvim;
        config = ''
          colorscheme kanagawa
        '';
      }
      { 
        plugin = vimdoc-ja;
        config = ''
          set helplang=ja,en
        '';
      }
    ];
  };
}
