# Aruna login and session design

## Current direction

Aruna uses Sway on Fedora Sericea. The login experience should remain minimal and professional, matching the blue/slate desktop identity.

## Safety-first integration

The base image's current display manager must be identified before changing login services. Replacing or enabling a second display manager without checking the base can cause competing services or a machine that reaches no graphical login.

The manual GitHub Actions workflow **Inspect Sericea login stack** pulls the current Sericea base image and reports:

- installed login-manager and greeter packages;
- the target of `display-manager.service`, if present;
- login-related systemd unit files.

Run that workflow before selecting or enabling a greeter. It does not modify or publish any image.

## Planned login experience

After the base audit, choose one supported route:

1. Keep the base display manager and customize its supported branding, if it can provide the desired experience.
2. Replace it deliberately with a Sway-compatible greetd greeter, with the previous display manager disabled in the same image change.

Do not enable two display managers at once. Keep a recovery path available during first-boot testing.

## Session

The Sway session already loads Aruna's wallpaper and provides the themed screen-lock shortcut. Login-manager integration is intentionally pending the base-image audit.
