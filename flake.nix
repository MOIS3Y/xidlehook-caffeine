{
  description = "Script to suspend the xidlehook process and then start it again";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    packages.${system}.xidlehook-caffeine = with pkgs;
      poetry2nix.mkPoetryApplication {
        projectDir = self;
        preferWheels = true;
        propagatedBuildInputs = [
          libnotify
          dunst
        ];
      };
    devShells.${system}.xidlehook-caffeine = pkgs.mkShellNoCC {
      shellHook = ''
        echo
        echo "▀▄▀ █ █▀▄ █░░ █▀▀ █░█ █▀█ █▀█ █▄▀ ▄▄ █▀▀ ▄▀█ █▀▀ █▀▀ █▀▀ █ █▄░█ █▀▀ ▀"
        echo "█░█ █ █▄▀ █▄▄ ██▄ █▀█ █▄█ █▄█ █░█ ░░ █▄▄ █▀█ █▀░ █▀░ ██▄ █ █░▀█ ██▄ ▄"
        echo "-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "
        echo
      '';
      packages = with pkgs; [
        (poetry2nix.mkPoetryEnv { projectDir = self; preferWheels = true; })
        libnotify
        dunst
      ];
    };
  };
}
