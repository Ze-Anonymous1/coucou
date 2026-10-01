# Red Light companion preview

**Project:** Coucou fork · **Task:** RED-LIGHT-PREVIEW · **Owner:** Codex · **State:** Implemented; local build unavailable in the current environment · **Updated:** 2026-10-01

## What this is

Choose **Preview Red Light Companion…** from Coucou's menu bar item. The notch panel opens in a pinned preview with sample System One activity. The three state buttons switch between working, waiting for permission, and finished examples. **Close preview** collapses the panel.

This is a UI prototype only. In the preview build, Coucou's Claude hook server, integrations pollers, and Keychain warm-up are disabled, so it won't compete with a normal Coucou install or read Red Light runtime state. The panel uses local sample text and does not connect to System One, create an agent task, open another app, or send an approval. The simulated permission state has no Allow or Deny action.

## Design review

- The preview is an explicit, named menu command beside the existing **Open Coucou** command. This follows Apple's guidance that menu items help people learn available commands and should stay consistently visible. The command opens the existing notch panel, retaining Coucou's native interaction model. Source: [Apple HIG: The menu bar](https://developer.apple.com/design/human-interface-guidelines/the-menu-bar), retrieved 2026-09-25.
- The menu bar extra can be hidden or moved by the user, so this is a development trigger for testing, not the final Red Light discoverability design. Apple says people decide whether to show a menu bar extra and recommends settings-based control and discoverability support. Product judgment: the persistent demo label and direct menu route are sufficient for this fork prototype.
- State choices use text labels as well as symbols and color, have accessibility labels, and never expose an approval affordance. This is a product safety and accessibility judgment for a simulated status surface.

## Acceptance checks

- The menu command opens the preview and pins it open.
- Each of the three controls changes only local sample presentation.
- Closing the preview returns to the existing compact panel behavior.
- Existing live task and approval flows are untouched.

## Build and try

On a Mac with Xcode 16+ and XcodeGen installed:

```sh
cd NotchBuddy
xcodegen
xcodebuild -scheme NotchBuddy -configuration Debug build \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS="DEBUG REDLIGHT_PREVIEW" \
  PRODUCT_BUNDLE_IDENTIFIER=dev.redlight.coucou-preview \
  PRODUCT_NAME="Coucou Red Light Preview" \
  INFOPLIST_KEY_CFBundleDisplayName="Coucou Red Light Preview"
```

Or, from the fork's GitHub page, open **Actions → Build → Run workflow**. The run's **Coucou-Red-Light-Preview-macOS** artifact contains the zipped app and is retained for seven days.

The compile condition disables live hooks and integration pollers. The artifact build also changes the app bundle identifier and display name after Xcode generates the plist, keeping it separate from an installed Coucou app. For a local build, set those three plist keys on the resulting app before launch:

```sh
APP="$(find "$HOME/Library/Developer/Xcode/DerivedData" -path '*/Build/Products/Debug/Coucou Red Light Preview.app' -print -quit)"
plutil -replace CFBundleIdentifier -string dev.redlight.coucou-preview "$APP/Contents/Info.plist"
plutil -replace CFBundleName -string 'Coucou Red Light Preview' "$APP/Contents/Info.plist"
plutil -replace CFBundleDisplayName -string 'Coucou Red Light Preview' "$APP/Contents/Info.plist"
```

Launch the app from DerivedData or Downloads directly; do not copy it over `/Applications/Coucou.app`.

## Verification

`git diff --check` passed. A native build could not be run here: `xcodebuild` resolves to Command Line Tools and reports that the active developer directory is not Xcode; XcodeGen is not installed. Build and on-device interaction remain to be verified on a Mac with Xcode.
