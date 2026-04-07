{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "bitwarden-desktop-appimage";
  version = "2026.3.1";

  src = fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-x86_64.AppImage";
    hash = "sha256-VXJURlXivLyLWImLudscjGH1abAxOzUXkTUA8Tc2Mgw=";
  };

  extraPkgs = pkgs: [
    pkgs.libsecret
    pkgs.udev
  ];
}
