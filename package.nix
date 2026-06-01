{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "bitwarden-desktop-appimage";
  version = "2026.4.0";

  src = fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-x86_64.AppImage";
    hash = "sha256-PFAEw2tQ8v7v7nPIWbiQFqcbP5EGOk02HVbRpOZIy0I=";
  };

  extraPkgs = pkgs: [
    pkgs.libsecret
    pkgs.udev
  ];
}
