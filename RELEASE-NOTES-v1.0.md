# mac-my-ro v1.0

Run RO Zero Global on an Apple Silicon Mac. The app installs and launches
the game itself — no Windows, no virtual machine, no manual Wine setup.

## Install

1. Download `mac-my-ro-1.0.zip` and unzip it.
2. Move `mac-my-ro.app` to your Applications folder.
3. Open it. **macOS will block it the first time** — the app is not
   notarised. Go to **System Settings → Privacy & Security** and choose
   **Open Anyway**. This is needed once, not on every launch.
4. Choose **Install RO** and select the official `RAG_SETUP_*.exe`.

The app downloads the game client itself — about 3.8 GB — so most of the
install is download time. An interrupted download resumes: run
**Install RO** again and it continues where it stopped.

Everything is installed to `~/Library/Application Support/mac-my-ro/`.
The app itself holds no game data, so replacing it never touches your
installation.

## Requirements

- Apple Silicon Mac (M1 or later), macOS 13 or later
- About 12 GB free disk space
- The official RO Zero installer

## What works

- Install, play, uninstall, reinstall
- **Play RO** starts the game through the official launcher
- **Game Settings** opens RO's own `Setup.exe` for resolution and graphics
- GameGuard initialises and the game reaches the world normally

## Known issues

- **Sessions can end early.** The server sometimes closes an otherwise
  healthy connection after a few minutes. This is under investigation and
  is not caused by anything the app does to GameGuard. Reconnecting works.

- **Lightly tested.** One Apple Silicon Mac, one macOS version, one
  account. A clean install, play and uninstall cycle was verified end to
  end, but Intel Macs, other macOS releases and unusual network setups
  have not been tried.

## Reporting problems

Use **Report Issue** in the app — it pre-fills your version and the path
to the newest log. Logs live in
`~/Library/Application Support/mac-my-ro/logs/` and are kept when you
uninstall.

## Licensing

### This application

Copyright (c) 2026 Tony Li. All rights reserved. See [`LICENSE`](LICENSE).

Free to use, including personal and non-commercial use. You may modify
your own copy. Redistribution must keep the licence and copyright notice
intact. You may **not** claim the work as your own or sell it as a
standalone product without written permission.

The app, its scripts, configuration, icon and packaging are original work
and are not open source.

### Bundled third-party components

Wine and vkd3d under the GNU LGPL 2.1 or later, plus FreeType, GnuTLS and
GMP under their own licences. Full texts and a written source offer ship
inside the app at `Contents/Resources/licenses/`. The corresponding source
is described in [`WINE-SOURCE.md`](WINE-SOURCE.md), with the patches in
[`patches/`](patches).

### Game content

No game files, art, or assets are redistributed. You supply the official
installer and the client downloads from Gravity's own servers. Use of the
client remains subject to the publisher's own terms of service.

## Disclaimer

Unofficial and not affiliated with, endorsed by, or approved by
Gravity Co., Ltd. or GNJOY. "Ragnarok Online", "RO Zero", "Poring" and
related marks belong to Gravity Co., Ltd.

## Checksum

```text
SHA-256  800f5a1b4bcc1f554e83c0fbec4376491e1cd84cd266faf85825322373957d78
         mac-my-ro-1.0.zip
```
