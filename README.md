# Aruna Linux

Aruna Linux is an independent, immutable desktop image based on Fedora Sericea (Sway Atomic), built with [BlueBuild](https://blue-build.org/).

## Project direction

- **Desktop:** Sway on Wayland
- **Base image:** Universal Blue Sericea
- **Image builder:** BlueBuild
- **Architecture:** x86_64 (initial target)
- **Image registry:** GitHub Container Registry (GHCR)
- **Build automation:** GitHub Actions

## Build

The initial image recipe is at `recipes/recipe.yml`.

The GitHub Actions workflow is currently manual-only. Before running it, configure image signing:

1. Generate a cosign key pair using the [BlueBuild signing guide](https://blue-build.org/how-to/cosign/).
2. Add the private key contents as the repository Actions secret named `SIGNING_SECRET`.
3. Commit the matching public key as `cosign.pub` in the repository root.
4. Open **Actions → Aruna Linux image → Run workflow**.

Do not commit or share `cosign.key`. Only `cosign.pub` belongs in this repository.

## Status

Early development. The current recipe is a minimal base-image build; Aruna branding, desktop configuration, application selection, update policy, and installer workflow are not implemented yet.

## License

License has not been selected yet.
