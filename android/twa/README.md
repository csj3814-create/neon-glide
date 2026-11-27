# NEON GLIDE Android TWA

Reproducible Trusted Web Activity wrapper for the Play Store listing.
It replaces the original PWABuilder-generated package, which was stuck at
`targetSdkVersion 35` and therefore blocked by the Play policy that requires
Android 16 (API 36) from 2026-08-31.

- Package ID: `io.github.csj3814_create.neonglide` (must not change — it is the
  published listing)
- Site: `https://neon.habitschool.kr/`
- `compileSdkVersion` / `targetSdkVersion`: 36
- `minSdkVersion`: 24 — raised from the published 23 because
  `androidbrowserhelper:2.7.4` will not merge below 24. This drops Android 6.0
  devices from future updates.
- Bubblewrap CLI: 1.24.1
- Android Browser Helper: 2.7.4
- Notifications disabled; `POST_NOTIFICATIONS` is not declared.

## Signing

The upload key is the one PWABuilder generated for the first release and must
stay the same, or Play will reject the upload:

- Keystore: `C:\Users\user\NeonGlide-PlayStore-KEYS\package\signing.keystore`
- Alias: `my-key-alias`
- Upload certificate SHA-256:
  `C4:EB:9E:5B:8F:DC:0A:9A:4B:22:3C:4B:F5:EA:74:20:10:2F:C8:90:F5:3C:AA:D3:93:FA:C6:84:9A:FC:C4:C7`

Keys, passwords, APKs and AABs are never committed.

## Build

```powershell
npm ci
npm run verify:target-sdk
.\tools\build-signed-aab.ps1
```

The signed bundle lands at
`app\build\outputs\bundle\release\neon-glide-signed.aab`.

Bump `appVersionCode` (and `appVersionName`) in `twa-manifest.json` before every
upload, then run `npx bubblewrap update --skipVersionUpgrade` and re-run
`npm run verify:target-sdk`.

`--skipVersionUpgrade` carries the old `versionName` into `app/build.gradle`, so
check that line against `twa-manifest.json` after every update and correct it by
hand if they disagree. Write the file without a BOM — Gradle refuses to parse one
("Unexpected character" on line 1), which `Set-Content -Encoding utf8` adds.

`enableSiteSettingsShortcut` must stay `true`. With it `false`, Bubblewrap leaves
`ManageDataLauncherActivity` out of the manifest, but
`androidbrowserhelper:2.7.4` still calls `setComponentEnabledSetting` on it from
`LauncherActivity.onCreate`, and the app dies on every launch with
`IllegalArgumentException: Component class ... does not exist`.

## Testing a build before it goes to Play

A Play upload burns a version code, so try the release APK on the local
emulator first:

```powershell
.\gradlew.bat assembleRelease
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$apksigner = (Get-ChildItem "$sdk\build-tools\*\apksigner.bat" | Sort-Object FullName -Descending | Select-Object -First 1).FullName
Copy-Item app\build\outputs\apk\release\app-release-unsigned.apk "$env:TEMP\neon-test.apk" -Force
& $apksigner sign --ks "$env:USERPROFILE\.android\debug.keystore" --ks-pass pass:android --ks-key-alias androiddebugkey --key-pass pass:android "$env:TEMP\neon-test.apk"
& "$sdk\emulator\emulator.exe" -avd Medium_Phone_API_36.1
& "$sdk\platform-tools\adb.exe" install -r "$env:TEMP\neon-test.apk"
& "$sdk\platform-tools\adb.exe" logcat -b crash
```

The debug signature means Digital Asset Links cannot verify, so the address bar
shows on the emulator. That is expected and says nothing about the Play build.

## Digital Asset Links

`/.well-known/assetlinks.json` in the site repo already lists both the Play App
Signing certificate and the upload certificate above, so link verification works
once the site is reachable.

## Icons

`iconUrl` and `maskableIconUrl` point at `raw.githubusercontent.com` rather than
the live site on purpose: Bubblewrap fetches them at generation time, and the
custom domain is not always resolvable. The runtime URL is unaffected — it comes
from `host` / `startUrl`.
