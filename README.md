# NsonEngine1-2-3-AI

**NsonEngine — a code maker. It generates C++ classes, full C++ projects,
Python scripts, and HTML pages from templates.**

## What it does

- Validates names and refuses to overwrite existing files
- Generates C++ classes (header + implementation)
- Generates complete C++ projects (main, CMakeLists, README)
- Generates Python scripts and HTML pages
- Keeps a history of everything it generated and lists its templates

Everything it creates goes into `NsonOutput/`. Menu: `1` generate a
C++ class, `2` generate a C++ project, `3` generate a Python script,
`4` generate an HTML page, `5` show history, `6` show templates,
`0` exit.

## Build and run

Requires C++17 (the engine uses `<filesystem>`). With Visual Studio,
open the solution and build Debug x64. Or with g++:

```sh
g++ -std=c++17 -Wall -Wextra -o "Nsonengine1 2 3 AI" "Nsonengine1 2 3 AI.cpp"
./"Nsonengine1 2 3 AI"
```

## Continuous integration

`.github/workflows/nson.yml` builds Debug x64 with MSBuild and runs a
scripted session, checking that a C++ project, a Python script, and an
HTML page are generated — and that the generated project itself builds
and runs. It also runs daily at 06:00 UTC.
