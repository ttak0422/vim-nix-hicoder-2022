{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vimdoc-ja
    vimdoc-ja = {
      url = "github:vim-jp/vimdoc-ja";
      flake = false;
    };
  };

  # inputs.XXX で入力を参照できるようにする
  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      inherit (builtins) getEnv;
      inherit (home-manager.lib) homeManagerConfiguration;
    in {
      homeConfigurations = {
        wslSample = let
          system = "x86_64-linux";
          overlay = (final: prev: {
            vimPlugins = prev.vimPlugins // {
              vimdoc-ja = buildVimPluginFrom2Nix {
                pname = "vimdoc-ja";
                version = "20XX-XX-XX";
                src = inputs.vimdoc-ja;
              };
            };
          });
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
          inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
        in homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}

