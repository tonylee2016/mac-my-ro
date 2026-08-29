# mac-my-ro

Run RO Zero Global on an Apple Silicon Mac. The app installs and launches
the game itself — no Windows, no virtual machine, no manual Wine setup.

Download the latest `mac-my-ro.app` from
[Releases](https://github.com/tonylee2016/mac-my-ro/releases).

## Requirements

- Apple Silicon Mac (M1 or later), macOS 13 or later
- About 12 GB free disk space
- The RO Zero installer, `RAG_SETUP_*.exe`, from the official site

## Install

1. Open `mac-my-ro.app`. macOS **will** block it the first time, because
   the app is not notarised. Go to **System Settings → Privacy & Security**
   and choose **Open Anyway**. This is needed once, not on every launch.
2. Read the disclaimer and choose **I Agree** to continue. The app exits
   without making changes if you choose **Quit** or close the notice.
3. Choose **Install RO** and select your `RAG_SETUP_*.exe`.
4. Wait for the official installer and required launcher components to finish.
5. The app then downloads the game client itself — about 3.8 GB — from the
   publisher's servers. This is most of the install time.
6. Choose **Play RO**.

Everything is installed to `~/Library/Application Support/mac-my-ro/`.
The app offers to move itself to your Applications folder on first run.

## Play

Open the app and choose **Play RO**. This runs the official launcher,
which then starts the game.

If the launcher ever misbehaves, set `RO_SKIP_PATCHER=1` to start the
game directly and skip it.

## Menu

| Item | What it does |
|---|---|
| Play RO | Runs the official launcher, which starts the game |
| Game Settings | Opens RO's own `Setup.exe` for resolution and graphics options |
| Install RO | Runs the official installer, then downloads the game client |
| Uninstall RO | Deletes the installed game. Asks twice. |
| Check for Updates | Opens the releases page |
| Report Issue | Opens a pre-filled issue with your version and log path |

If the client download is interrupted, choose **Install RO** again. It
resumes from where it stopped rather than starting over.

## Troubleshooting

Logs are kept in `~/Library/Application Support/mac-my-ro/logs/`. Attach
the newest `install-*.log` or `ro-session-*.log` when reporting a
problem; **Report Issue** fills in the path for you.

Uninstalling keeps the logs.

## Wine source (LGPL)

The app bundles Wine, licensed under the GNU LGPL 2.1 or later. The
corresponding source is:

1. CodeWeavers' published CrossOver source release,
   `crossover-sources-26.3.0.tar.gz`, containing the Wine 11.0 tree.
2. The modifications applied to it, in [`patches/`](patches):
   - `crossover-26.3-unix-ntload-driver.patch` — implements
     `NtLoadDriver` in the Unix-side ntdll, which GameGuard requires.
   - `wine-11.0-winhttp-number64.patch` — accepts
     `WINHTTP_QUERY_FLAG_NUMBER64` in `WinHttpQueryHeaders`. Wine rejects
     that flag and returns `ERROR_INVALID_PARAMETER`, which is why the
     official launcher reports `0x00000057` when it tries to size the
     full client download.

Only the Wine portions are covered by the LGPL.

The exact Wine source archive, patch hashes, and a minimal Wine-only rebuild
recipe are documented in [`WINE-SOURCE.md`](WINE-SOURCE.md). That recipe does
not contain the application's product, certificate, signing, or packaging
logic.

## Disclaimer

This is an unofficial, community-made project. It is not affiliated with,
endorsed by, sponsored by, or approved by Gravity Co., Ltd., GNJOY, or any
of their affiliates.

"Ragnarok Online", "RO Zero", "Poring" and all related characters, names,
marks and artwork are trademarks or registered trademarks of Gravity Co.,
Ltd. This project claims no rights in them and redistributes none of them:
no game files, art, or assets are included here or in the application. You
supply the official installer, and the game client is downloaded from
Gravity's own servers.

The application icon is original artwork created for this project and is
not taken from the game.

Use of the game client remains subject to the publisher's own terms of
service.

## License

The application, its scripts and its configuration are separate works
that use Wine. They are Copyright (c) 2026 Tony Li, are not open source,
and may be used free of charge under the terms in `LICENSE`.

Game files and Microsoft runtimes are not redistributed here and remain
under their own licenses.
