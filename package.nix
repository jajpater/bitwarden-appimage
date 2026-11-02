{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "bitwarden-desktop-appimage";
  version = "2026.10.2";

  src = fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-x86_64.AppImage";
    hash = "sha256-B85pNCeYQzKDK+CInmUqdKZcHwtoDPn8NoSm+wRYSUw=";
  };

  extraPkgs = pkgs: [
    pkgs.libsecret
    pkgs.udev
  ];
}
