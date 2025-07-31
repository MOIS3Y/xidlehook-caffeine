{
  description = ''
    xidlehook-caffeine - a script to pause and unpause xidlehook processes
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in {
      packages = rec {
        xidlehook-caffeine = pythonPackages.buildPythonApplication {
          pname = "xidlehook-caffeine";
          version = "0.1.0";
          format = "pyproject";
          src = self;

          nativeBuildInputs = [
            pythonPackages.poetry-core
          ];
          dependencies = [
            pythonPackages.psutil
            pkgs.dunst
            pkgs.libnotify
          ];
        };
        default = xidlehook-caffeine;
      };
      apps = rec {
        xidlehook-caffeine = flake-utils.lib.mkApp {
          drv = self.packages.${system}.xidlehook-caffeine;
        };
        default = xidlehook-caffeine;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          python
          pkgs.poetry
          pythonPackages.psutil
          pythonPackages.flake8
        ];

        shellHook = ''
          poetry env use ${python}/bin/python
          poetry install
        '';
      };
  });
}
