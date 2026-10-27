# RainStream

Public RLBot v5 version of **Rain**, by Rou_Ad and RichardsWorld.
One bot automatically selects a separate checkpoint for each match format.

| Format | Checkpoint | Directory |
| --- | --- | --- |
| 1v1 | Rain 100B (`100000397482`) | `rlbot/checkpoint_1v1` |
| 2v2 | Rain 86B (`86685842906`) | `rlbot/checkpoint_2v2` |
| 3v3 | Rain "68B" (recorded steps: `77573170866`) | `rlbot/checkpoint_3v3` |

Selection uses the larger team's size. Inference is deterministic (argmax), with
231 observations, tick skip 6 and action delay 5. All three models load at startup.

## Play on Windows

Download **RainStream-Windows.zip** from the [latest release](https://github.com/Reiud-Ad/RainStream/releases/latest),
extract the entire archive, and add `RainStream/rlbot/bot.toml` to RLBot v5.
The release includes the executable, its matching CPU LibTorch DLLs, all three
checkpoints, loadout and logo. Keep the directory structure intact.

The Git repository contains source and models; its runtime binaries are in the release.

## Botpack / bob

Repository: `https://github.com/Reiud-Ad/RainStream.git`

Bot config: **`rlbot/bot.toml`**. Builder config: **`bob.toml`** at the repository root.
The botpack can include this repository as a Git submodule. The source dependencies
are vendored, including their existing licenses, so there are no nested submodules.

The existing `cpp.Dockerfile` builds Linux and Windows packages with bob. Both
packages preserve all three checkpoint directories and include the required runtime.

```sh
docker build -f cpp.Dockerfile -t rainstream .
docker run --rm rainstream > rainstream.tar
```

## Local Windows build

Install Visual Studio C++ tools, CMake and the matching CPU LibTorch distribution:

```sh
cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DLIBTORCH_ROOT="C:/path/to/libtorch"
cmake --build build --config Release --target GGLBot --parallel 2
```

Start through `rlbot/run.bat`. The LibTorch used at runtime must match the build.
Third-party source licenses are retained under `cpp-interface` and `inc/RocketSim`.
This public copy does not include training code, optimizer checkpoints or private configuration.
