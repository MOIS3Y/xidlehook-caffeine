{
  description = "Script to suspend the xidlehook process and then start it again";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
      inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
    in {

    # Executed by `nix build .#<name>
    # ? Example: nix build .#xidlehook-caffeine 
    packages.${system} = {
      xidlehook-caffeine = with pkgs; mkPoetryApplication { 
        projectDir = self; 
        preferWheels = true;
        propagatedBuildInputs = [
          libnotify
          dunst
        ];
      };
      default = self.packages.${system}.xidlehook-caffeine;
    };

    # Executed by `nix run . -- <args?>`
    # ? example: nix run .#xidlehook-caffeine -- --version
    apps.${system}.xidlehook-caffeine = {
      type = "app";
      program = "${self.packages.${system}.xidlehook-caffeine}/bin/xidlehook-caffeine";
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
        (mkPoetryEnv { projectDir = self; preferWheels = true; })
        libnotify
        dunst
      ];
    };
  };
}
