# DynamoVersionPatcher

A small command-line utility that upgrades the **DynamoCore runtime** bundled with Autodesk products — no reinstall, no waiting for a service pack.

Supported hosts (auto-detected from your Autodesk installation):
- **Autodesk Revit** (any year)
- **Autodesk Civil 3D** (any year)

> **Use at your own risk.** This tool modifies files inside your Autodesk installation. It is unofficial and unaffiliated with Autodesk or the Dynamo team. A backup is taken automatically before any changes are made.

> **Intended for minor patch updates only.** This tool is designed to apply small, incremental runtime updates (e.g. 3.6.x → 3.6.y) — not to jump across major or minor versions. Using it to bridge large version gaps is untested and likely to cause instability or breakage.

## Why this exists

Autodesk ships a specific version of DynamoCore with each product release, and it doesn't always keep pace with the latest fixes and improvements coming out of the Dynamo open-source project. This tool lets you apply a newer runtime yourself — immediately, on your own terms.

It was built to answer the question "what if" and shared here in the hope that others find it useful too.

## What it does

1. Checks that you are running as Administrator and that the target application is closed.
2. Backs up your current Dynamo installation to `Documents\Dynamo<Host>_Backup`.
3. Fetches the list of available DynamoCoreRuntime builds and lets you pick one.
4. Downloads the selected runtime zip and extracts it into the Dynamo directory for your chosen host.
5. Verifies the installed version matches the selected target.

Host-specific bridge files (e.g. `DynamoRevitDS.dll`) are left untouched — only the core runtime is updated.

## Requirements

- Windows 10/11 (64-bit)
- Autodesk Revit or Civil 3D with Dynamo installed
- Administrator privileges
- An internet connection (or a pre-downloaded zip — see `--zip-path`)

## Quick start

1. **Close Revit or Civil 3D** completely.
2. Download `DynamoCoreUpdate.exe` from the [Releases](../../releases) page.
3. Right-click the `.exe` and choose **Run as administrator**.
4. Select your host application, then select the runtime version to install.

The tool will download the runtime (~50 MB), extract it, and confirm the new version.

### Windows SmartScreen

You'll likely see a SmartScreen prompt the first time you run it — this is normal for any unsigned `.exe` from the internet. Click **More info → Run anyway** to proceed. If you'd rather not bypass it, feel free to [build from source](#building-from-source) and review the code yourself.

## Options

Run from an administrator command prompt for more control:

```
DynamoCoreUpdate.exe [--host <key>] [--version <version>] [--install-dir <path>] [--zip-path <file>] [--build-dir <path>] [--backup-dir <path>] [--no-backup] [--force]
```

| Flag | Description |
|------|-------------|
| `--host <key>` | Target host key (e.g. `revit-2026`, `civil3d-2026`). If omitted, an interactive menu is shown |
| `--version <version>` | Runtime version to install (e.g. `3.6.2`). Use `latest` for the newest stable release. If omitted, an interactive picker is shown |
| `--install-dir <path>` | Path to the Dynamo folder. Defaults to the standard location for the selected host |
| `--zip-path <file>` | Use a locally downloaded zip instead of fetching from the build server |
| `--build-dir <path>` | Use a local build directory instead of downloading |
| `--backup-dir <path>` | Override the default backup location |
| `--no-backup` | Skip the backup step entirely |
| `--force` | Re-install even if already on the target version |

### Default install directories

| Host | Default path |
|------|-------------|
| Revit 2026 | `C:\Program Files\Autodesk\Revit 2026\AddIns\DynamoForRevit` |
| Civil 3D 2026 | `C:\Program Files\Autodesk\AutoCAD 2026\C3D\Dynamo\Core` |

### Examples

```
# Interactive host and version selection
DynamoCoreUpdate.exe

# Target Revit 2026 directly (skips host menu, shows version picker)
DynamoCoreUpdate.exe --host revit-2026

# Install a specific version on Civil 3D 2026
DynamoCoreUpdate.exe --host civil3d-2026 --version 3.6.2

# Install the latest stable release
DynamoCoreUpdate.exe --host revit-2026 --version latest

# Use a local zip (useful on air-gapped machines)
DynamoCoreUpdate.exe --host revit-2026 --zip-path "D:\Downloads\DynamoCoreRuntime3.6.2.11575.zip"

# Non-standard install location
DynamoCoreUpdate.exe --host civil3d-2026 --install-dir "D:\Autodesk\Civil3D 2026\Dynamo"
```

## Restoring from backup

Only the files that the zip would overwrite are backed up. A timestamp is appended to the folder name on each run (e.g. `DynamoForRevit_2026_Backup_20250401_143022`) so reruns never conflict.

To restore, copy the backup folder contents back over the install directory using Windows Explorer, or via the command line:

```
xcopy /E /H /Y "%USERPROFILE%\Documents\DynamoForRevit_2026_Backup_<timestamp>\*" "C:\Program Files\Autodesk\Revit 2026\AddIns\DynamoForRevit\"
```

## Notes

- The tool auto-discovers any Revit or Civil 3D installation found under `C:\Program Files\Autodesk`. Use `--install-dir` for non-standard paths.
- This tool operates independently of Autodesk's update mechanism — a product repair or update may revert the patched files.

## Building from source

Requires the [.NET 9 SDK](https://dotnet.microsoft.com/download).

```bash
# Standard build
dotnet build src/DynamoCoreUpdate.csproj -c Release

# Single self-contained .exe
dotnet publish src/DynamoCoreUpdate.csproj -c Release -p:PublishSingleFile=true
```

Output lands in `src/bin/Release/net9.0-windows/win-x64/publish/` and is also copied to `src/dist/`.

## Releases

Releases are published automatically when a pull request is merged to `main`. Each release bumps the patch version, builds a fresh single-file exe, and attaches it to a GitHub Release with auto-generated notes.

## Contributing / Issues

Feedback, bug reports, and pull requests are all welcome — especially for supporting other Autodesk versions. [Open an issue](../../issues) to get the conversation started.

## License

MIT — see [LICENSE](LICENSE).

---

*This project was created independently in the author's personal time and is entirely separate from any official development by the Dynamo team or Autodesk. It is not affiliated with, endorsed by, or supported by Autodesk, Inc. in any way. Dynamo, Revit, and Civil 3D are trademarks of Autodesk, Inc.*
