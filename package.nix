{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "bitwarden-desktop-appimage";
  version = "2026.5.0";

  src = fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-x86_64.AppImage";
    hash = "sha256-QbvzhEZxF1QXu3/9cxW9HdAO+CczZmU2TTQOnSfiO7k=";
  };

  extraPkgs = pkgs: [
    pkgs.libsecret
    pkgs.udev
  ];
}
