# DynamoRevitPatcher

> ### ⚠️ USE AT YOUR OWN RISK
>
> **This tool overwrites files inside your Autodesk Revit installation directory.** It is an unofficial, unsupported utility with no affiliation with Autodesk or the Dynamo team. It has not been tested on every system configuration.
>
> **Potential consequences include — but are not limited to:**
> - Revit failing to launch or crashing unexpectedly
> - Dynamo nodes, scripts, or graphs breaking
> - Loss of your existing Dynamo installation (use `--backup-dir` to mitigate this)
> - Violating your Autodesk license agreement
>
> **Always back up your Dynamo installation before running this tool** (see [Options](#options) below). The author(s) of this tool accept no responsibility for damage to your software, files, or projects.

---

A small command-line utility that upgrades the **DynamoCore runtime** bundled with Revit 2026 to version **3.6.2** — without reinstalling Revit or waiting for an official Autodesk update.

## Why this exists

Autodesk ships a specific version of DynamoCore with each Revit release, and that version doesn't always keep pace with the latest fixes and improvements from the Dynamo open-source project. If you've run into bugs, performance issues, or missing features that have already been resolved in a newer DynamoCore release, this tool lets you apply that update yourself — immediately, without waiting for the next Revit service pack.

This was built out of personal frustration with a specific issue and shared here in the hope that others find it useful.

## What it does

1. Checks that you are running as Administrator and that Revit is closed.
2. Downloads the official `DynamoCoreRuntime3.6.2` zip directly from the [DynamoDS GitHub releases page](https://github.com/DynamoDS/Dynamo/releases).
3. Extracts the runtime files into your existing Revit 2026 DynamoForRevit directory, overwriting the older DynamoCore files.
4. Verifies the installed version matches the expected target.

The Revit-specific Dynamo files (e.g. `DynamoRevitDS.dll`) are **not replaced** — only the core runtime is updated.

## Requirements

- Windows 10/11 (64-bit)
- Autodesk Revit **2026** with DynamoForRevit installed
- Administrator privileges
- An internet connection (or a pre-downloaded zip — see `--zip-path`)

## Known limitations

- **Revit 2026 only.** The default install path targets Revit 2026. Other Revit versions may work with `--install-dir`, but have not been tested.
- **DynamoCore only.** The Revit-specific Dynamo bridge (`DynamoRevitDS.dll` and related files) is intentionally left untouched. If those files are mismatched with the new core, you may see errors.
- This is a proof-of-concept tool. It does not integrate with Autodesk's update mechanism and will not prevent Autodesk from overwriting the patched files if you repair or update Revit.

## Quick start

1. **Close Revit** completely.
2. Download `DynamoCoreUpdate.exe` from the [Releases](../../releases) page.
3. Right-click the `.exe` and choose **Run as administrator**.
4. Follow the on-screen prompts.

That's it. The tool will download the runtime (~50 MB), extract it, and confirm the new version.

### Windows SmartScreen warning

Because this `.exe` is unsigned, Windows SmartScreen will likely show a blue warning dialog the first time you run it:

> *"Windows protected your PC — Microsoft Defender SmartScreen prevented an unrecognized app from starting."*

This is expected for any unsigned executable downloaded from the internet. If you trust the source:

1. Click **More info**
2. Click **Run anyway**

If you prefer not to bypass SmartScreen, you can [build the tool from source](#building-from-source) yourself — the code is fully open and auditable here.

## Options

The tool can also be run from an administrator command prompt with optional flags:

```
DynamoCoreUpdate.exe [--install-dir <path>] [--zip-path <file>] [--backup-dir <path>] [--force]
```

| Flag | Description |
|------|-------------|
| `--install-dir <path>` | Path to the DynamoForRevit folder. Defaults to `C:\Program Files\Autodesk\Revit 2026\AddIns\DynamoForRevit` |
| `--zip-path <file>` | Use a locally downloaded zip instead of downloading from GitHub |
| `--backup-dir <path>` | Copy the current installation to this directory before patching (strongly recommended) |
| `--force` | Re-install even if the target version is already present |

### Example: backup before patching

```
DynamoCoreUpdate.exe --backup-dir "C:\DynamoBackup"
```

### Example: use a local zip (air-gapped machines)

```
DynamoCoreUpdate.exe --zip-path "D:\Downloads\DynamoCoreRuntime3.6.2.11575.zip"
```

### Example: non-standard install path

```
DynamoCoreUpdate.exe --install-dir "D:\Autodesk\Revit 2026\AddIns\DynamoForRevit"
```

## Restoring from backup

If something goes wrong, copy the contents of your `--backup-dir` back over the DynamoForRevit folder:

```
xcopy /E /H /Y "C:\DynamoBackup\*" "C:\Program Files\Autodesk\Revit 2026\AddIns\DynamoForRevit\"
```

Or use Windows Explorer to copy-paste the backup folder contents back.

## Building from source

Requires the [.NET 9 SDK](https://dotnet.microsoft.com/download).

```bash
# Standard build
dotnet build src/DynamoCoreUpdate.csproj -c Release

# Single self-contained .exe
dotnet publish src/DynamoCoreUpdate.csproj -c Release /p:PublishSingleFile=true
```

The output `.exe` will be in `src/bin/Release/net9.0-windows/win-x64/`.

## Contributing / Issues

Found a bug, or does it not work on your setup? Please [open an issue](../../issues) — feedback is welcome. Pull requests are also appreciated, especially for supporting other Revit versions.

## License

MIT — see [LICENSE](LICENSE).

---

*This project was created independently in the author's personal time and is entirely separate from any official development by the Dynamo team or Autodesk. It is not affiliated with, endorsed by, or supported by Autodesk, Inc. in any way. Dynamo and Revit are trademarks of Autodesk, Inc.*
