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

## Digital Asset Links

`/.well-known/assetlinks.json` in the site repo already lists both the Play App
Signing certificate and the upload certificate above, so link verification works
once the site is reachable.

## Icons

`iconUrl` and `maskableIconUrl` point at `raw.githubusercontent.com` rather than
the live site on purpose: Bubblewrap fetches them at generation time, and the
custom domain is not always resolvable. The runtime URL is unaffected — it comes
from `host` / `startUrl`.
