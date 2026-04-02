{
  description = "Bitwarden Desktop AppImage flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages = {
          default = pkgs.callPackage ./package.nix { };
          bitwarden-appimage = pkgs.callPackage ./package.nix { };
        };

        apps.default = {
          type = "app";
          program = "${pkgs.callPackage ./package.nix { }}/bin/bitwarden-desktop-appimage";
        };
      });
}
