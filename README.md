# Aruna Linux

Aruna Linux is an independent, immutable desktop image based on Fedora Sway Atomic, built with [BlueBuild](https://blue-build.org/).

## Project direction

- **Desktop:** Sway on Wayland
- **Base image:** Fedora Sway Atomic 45 (`quay.io/fedora-ostree-desktops/sway-atomic:45`)
- **Image builder:** BlueBuild
- **Architecture:** x86_64 (initial target)
- **Image registry:** GitHub Container Registry (GHCR)
- **Build automation:** GitHub Actions

Fedora renamed Sericea to Sway Atomic and moved the container image to the `fedora-ostree-desktops/sway-atomic` repository on Quay.

## Aruna desktop identity

The initial desktop configuration uses a blue and slate palette:

- Sway window borders and focused-window colors are customized.
- Waybar uses a dark slate surface with blue highlights.
- The top bar displays workspaces, mode, clock, network, CPU, memory, audio, and system tray.
- The Aruna abstract wallpaper is installed under `/usr/share/backgrounds/aruna/`.
- `swaybg` starts the wallpaper in the Sway session.
- `swaylock` provides the matching lock-screen palette; the default shortcut is `Super+Shift+X`.

System-wide configuration is maintained under `files/system/` and installed by the BlueBuild `files` module. Desktop packages are declared in `recipes/desktop-packages.yml`.

## Build and signing

The image build workflow is manually triggered from **Actions → Aruna Linux image → Run workflow**.

The image recipe includes BlueBuild's signing module:

1. Generate a cosign key pair.
2. Add the private key contents as the repository Actions secret named `SIGNING_SECRET`.
3. Commit the matching public key as `cosign.pub` in the repository root.
4. Never commit or share `cosign.key`.

The first successful image build was published to GHCR and its signature was verified against the repository public key.

## Installer ISO

The **Aruna Linux installer ISO** workflow can be manually triggered from **Actions → Aruna Linux installer ISO → Run workflow**. It generates an x86_64 installer ISO from the published GHCR image and uploads it as a workflow artifact.

The ISO workflow is an initial x86_64 installer path. Booting with 32-bit IA32 UEFI firmware (for example, some Bay Trail devices) is not yet integrated or validated. Adding a `BOOTIA32.EFI` file alone is not sufficient unless the EFI boot image and GRUB configuration are also compatible.

## Current status

Early development. The first customized image has been built, published, and signature-verified. The installer ISO workflow has been added but still needs a successful CI run and hardware testing. Actual installation, first boot, and IA32 UEFI compatibility have not yet been verified.

## License

License has not been selected yet.
