# NsonEngine — workflow notes

NsonEngine is a computer code maker: it generates real files from
templates — C++ classes, full C++ projects (with CMake), Python scripts,
and HTML pages — into `NsonOutput/`, with name validation and a
generation history for the session.

## Systems

- **CodeValidator** — names must start with a letter or underscore and
  contain only letters, digits, and underscores.
- **FileMaker** — creates directories, refuses to overwrite existing
  files, reports file errors.
- **TemplateLibrary** — C++ main, Python main, HTML page, C++ class
  header/implementation, CMake project file, README.
- **CodeGenerator** — GenerateCpp (class .h + .cpp), GenerateCppProject
  (main.cpp + CMakeLists.txt + README.md), GeneratePython (.py),
  GenerateHTML (.html); DisplayHistory, DisplayTemplates.
- **NsonCore** — menu (generate class/project/Python/HTML, templates,
  history, exit).

## Project file fix

The repo's `.vcxproj` had no `LanguageStandard`, so MSVC would default
to C++14 — but the engine uses `<filesystem>`, which needs C++17.
`<LanguageStandard>stdcpp17</LanguageStandard>` was added to all four
configurations (same fix as AIDoors9). The project file already builds
`Nsonengine1 2 3 AI.cpp` as its only source file.

## Build

MSBuild (Debug x64):

```
msbuild "Nsonengine1 2 3 AI.vcxproj" /p:Configuration=Debug /p:Platform=x64
```

## Workflow

`.github/workflows/nson.yml` (windows-latest):

1. Checks out the repo.
2. Builds the project in Debug x64 with MSBuild (no `|| echo` — a
   failed build fails the run).
3. Runs the smoke test: feeds a scripted session from a file
   (`cmd /c "exe < smoke-input.txt"`, no PowerShell piping) and fails
   unless the exe exits 0, generates a C++ project, a Python script
   and an HTML page, writes the generated files, and shuts down
   cleanly. It then builds the generated C++ project with CMake and
   fails unless it prints its greeting. The program output is printed
   to the log.
4. Runs every day at 06:00 UTC (01:00 EST).

Muse cannot write `.github/workflows/*` through the GitHub API, so the
workflow file is added by hand in the GitHub web UI:
create `.github/workflows/nson.yml` on the master branch and paste in
the file contents.

## Local check

```
sh scripts/nson-check.sh
```

Compiles with g++, runs the scripted session in a temp directory,
checks the output and the generated files, builds and runs the
generated C++ project, and runs the generated Python script.
