{
  description = "Léon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        unstable = import nixpkgs-unstable {
          inherit system;
          # claude-code is marked unfree upstream; allow it only as a bundled fallback.
          config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [ "claude-code" ];
        };

        nvimConfig = pkgs.runCommand "nvim-config" {} ''
          mkdir -p "$out/lua"
          cp -vr ${./lua}/. "$out/lua/"
        '';

        neovimWithPlugins = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          vimAlias = true;
          viAlias = true;
          # --suffix PATH lets a system-installed `claude` win, but bundles one as a fallback.
          extraMakeWrapperArgs = "--set VIMRUNTIME ${pkgs.neovim-unwrapped}/share/nvim/runtime --suffix PATH : ${unstable.claude-code}/bin";

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
              gitsigns-nvim
              vim-sleuth
              git-conflict-nvim
              vim-surround

              sonokai
              nvim-treesitter.withAllGrammars

              # Claude Code integration (from nixpkgs-unstable; not yet in 25.05)
              unstable.vimPlugins.claudecode-nvim
              unstable.vimPlugins.snacks-nvim
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
