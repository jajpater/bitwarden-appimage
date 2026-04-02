# bitwarden-appimage

Kleine flake die de officiele Bitwarden Desktop `AppImage` als Nix package aanbiedt.

## Doel

Deze repo is bedoeld als aparte packagebron voor Bitwarden Desktop via de officiele upstream `AppImage`.

Waarom apart:

- in `nixpkgs` wordt `bitwarden-desktop` uit bron opgebouwd
- dat kan lokaal zwaar zijn bij cache-miss
- deze flake gebruikt juist de upstream binary-distributie

## Update

Werk de package-definitie bij naar de nieuwste desktoprelease met:

```bash
./scripts/update-version.sh
```

Daarna kun je de wijziging committen en in een andere repo binnenhalen met:

```bash
nix flake update bitwarden-appimage
```

Verwachte workflow:

1. draai `./scripts/update-version.sh`
2. controleer de diff
3. commit en push deze repo
4. update daarna in de consumer-repo de flake lock

Deze opzet maakt `nix flake update` in de consumer-repo bruikbaar, omdat de versie/hash niet meer in die consumer-repo zelf staat.

## Gebruik

Voorbeeld als flake-input:

```nix
inputs.bitwarden-appimage.url = "git+file:///home/jajpater/Develop/mygithub/bitwarden-appimage";
```

En daarna:

```nix
bitwarden-appimage.packages.${pkgs.stdenv.hostPlatform.system}.default
```

## Bestanden

- [flake.nix](/home/jajpater/Develop/mygithub/bitwarden-appimage/flake.nix)
  Expose't de package als flake-output.

- [package.nix](/home/jajpater/Develop/mygithub/bitwarden-appimage/package.nix)
  Definieert de AppImage-package.

- [scripts/update-version.sh](/home/jajpater/Develop/mygithub/bitwarden-appimage/scripts/update-version.sh)
  Werkt version, URL en hash bij.
