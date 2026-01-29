{
  description = "Léon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        nvimConfig = pkgs.runCommand "nvim-config" {} ''
          mkdir -p "$out/lua"
          cp -vr ${./lua}/. "$out/lua/"
        '';

        neovimWithPlugins = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          vimAlias = true;
          viAlias = true;
          extraMakeWrapperArgs = "--set VIMRUNTIME ${pkgs.neovim-unwrapped}/share/nvim/runtime";
        
          configure = {
            # Add your Lua config to runtimepath
            customRC = ''
              set runtimepath^=${nvimConfig}
              lua require("init")
            '';
        
          packages.myPlugins.start = with pkgs.vimPlugins; [
              blink-cmp # TODO: Needs configuration in lua
              nvim-lspconfig
              nvim-tree-lua
              nvim-web-devicons
              telescope-nvim
              plenary-nvim
              lualine-nvim
              undotree
              nvim-colorizer-lua
              vim-fugitive
              vim-sleuth
              git-conflict-nvim
              vim-surround

              dracula-vim
              nvim-treesitter.withAllGrammars
            ];
          };
        };
      in {
        # The default build
        packages.default = neovimWithPlugins;

        # Also export both pieces separately for use in Home Manager
        packages.nvimConfig = nvimConfig;
        packages.neovimWithPlugins = neovimWithPlugins;

        # Optional: expose as an app so you can run `nix run .`
        apps.default = flake-utils.lib.mkApp {
          drv = neovimWithPlugins;
        };
      }
    );
}
