# README workflow

Deze repo gebruikt GitHub Actions om automatisch te controleren of er een nieuwe Bitwarden Desktop `AppImage` release is.

## Bestanden

- [.github/workflows/update-bitwarden.yml](/home/jajpater/Develop/mygithub/bitwarden-appimage/.github/workflows/update-bitwarden.yml)
  GitHub Actions workflow die het updatescript draait en een PR maakt als er iets verandert.

- [scripts/update-version.sh](/home/jajpater/Develop/mygithub/bitwarden-appimage/scripts/update-version.sh)
  Script dat `package.nix` bijwerkt naar de nieuwste `desktop-v...` release.

## Hoe het werkt

De workflow draait op twee manieren:

- handmatig via `workflow_dispatch`
- automatisch via `schedule`

De huidige cron is:

```yaml
17 6 * * 1
```

Dat betekent wekelijks op maandag rond `06:17` UTC.

## Wat de workflow doet

1. checkt de repo uit
2. installeert Nix
3. draait `./scripts/update-version.sh`
4. maakt of vernieuwt een pull request als `package.nix` is veranderd

## Waarom PR en geen directe push?

Een PR is hier veiliger en transparanter:

- je ziet precies welke version/hash veranderd is
- je houdt controle over merge-momenten
- het is makkelijker om failures of onverwachte sprongen te beoordelen

## Verwachte workflow

In deze repo:

1. GitHub Actions opent een PR bij een nieuwe release
2. je reviewt en merge't die PR

In een consumer-repo zoals `nixos-config`:

1. `nix flake update bitwarden-appimage`
2. commit de bijgewerkte lockfile
3. voer je normale rebuild uit

## Vereisten

- de repo moet op GitHub staan
- GitHub Actions moet ingeschakeld zijn
- de default branch moet de workflow bevatten

De workflow gebruikt de standaard `GITHUB_TOKEN` met:

- `contents: write`
- `pull-requests: write`

Daarmee kan de action zelfstandig een update-PR aanmaken.
