# Aruna login and session design

## Current implementation

Aruna uses SDDM 0.21.0 on Fedora Sway Atomic 45. The base image includes the Qt 6.11.2 runtime, Qt Quick/QML, and the SDDM Wayland Sway session integration.

Aruna keeps SDDM and installs its own theme at:

- `/usr/share/sddm/themes/aruna`
- `/etc/sddm.conf.d/10-aruna-theme.conf`

The configuration selects `Current=aruna`. The theme uses the SDDM-provided `SddmComponents 2.0` controls for username, password, session selection, login, restart, and shutdown. It does not replace or enable another display manager.

## Validation

The **Inspect Fedora Sway Atomic login stack** workflow runs when the theme, its SDDM configuration, or its inspection workflow changes. It checks that the expected theme files exist, verifies the base SDDM/Qt runtime packages, and checks the integration points used by the QML theme.

This CI check is a static integration check; a successful run does not replace testing the greeter on actual display hardware.

## Session

The SDDM session selector uses the sessions provided by the base image. Aruna's Sway session continues to load the blue desktop theme and wallpaper after login.
