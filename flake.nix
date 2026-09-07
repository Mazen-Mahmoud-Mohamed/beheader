{
  description = "A Flake providing everything needed to run beheader";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs { inherit system; };
          system = system;
        }
      );
    in {
      packages = forAllSystems ({ pkgs, ... }: {
        default = pkgs.buildEnv {
          name = "beheader-env";
          paths = [
            pkgs.ffmpeg
            pkgs.imagemagick
            pkgs.zip
            pkgs.unzip
            pkgs.bun
            pkgs.bento4
          ];
        };
      });
    };
}
