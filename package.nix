{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "bitwarden-desktop-appimage";
  version = "2026.2.1";

  src = fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-x86_64.AppImage";
    hash = "sha256-QBiMa1CbKRnXcO3kLi+xEfux+JeNiXllalzE8ToFZcA=";
  };

  extraPkgs = pkgs: [
    pkgs.libsecret
    pkgs.udev
  ];
}
