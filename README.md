# Aruna Linux

Aruna Linux is an independent, immutable desktop image based on Fedora Sericea (Sway Atomic), built with [BlueBuild](https://blue-build.org/).

## Project direction

- **Desktop:** Sway on Wayland
- **Base image:** Universal Blue Sericea (`ghcr.io/ublue-os/sericea-main`)
- **Image builder:** BlueBuild
- **Architecture:** x86_64 (initial target)
- **Image registry:** GitHub Container Registry (GHCR)
- **Build automation:** GitHub Actions

## Aruna desktop identity

The initial desktop configuration uses a blue and slate palette:

- Sway window borders and focused-window colors are customized.
- Waybar uses a dark slate surface with blue highlights.
- The top bar displays workspaces, mode, clock, network, CPU, memory, audio, and system tray.

System-wide configuration is maintained under `files/system/` and installed by the BlueBuild `files` module.

## Build and signing

The GitHub Actions workflow is currently manual-only. The image recipe includes BlueBuild's signing module, so a matching cosign key pair must be configured before the first successful publish:

1. Generate a cosign key pair.
2. Add the private key contents as the repository Actions secret named `SIGNING_SECRET`.
3. Commit the matching public key as `cosign.pub` in the repository root.
4. Open **Actions → Aruna Linux image → Run workflow**.

Do not commit or share `cosign.key`. Only `cosign.pub` belongs in this repository.

## Current status

Early development. The base image and first Sway/Waybar theme files are in place. The image has not yet been built or published. Application selection, update policy, installer workflow, and release process remain future work.

## License

License has not been selected yet.
