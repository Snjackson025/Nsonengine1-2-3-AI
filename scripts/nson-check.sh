#!/bin/sh
# nson-check.sh — local check for NsonEngine.
# Compiles the engine, runs a scripted session (C++ class, C++ project,
# Python script, HTML page, history), verifies the generated files, and
# builds + runs the generated C++ project and Python script.
# Run from the repo root: sh scripts/nson-check.sh
set -e
cd "$(dirname "$0")/.."

CXX="${CXX:-g++}"
echo "== compile =="
"$CXX" -std=c++17 -Wall -Wextra -o /tmp/nson_check "Nsonengine1 2 3 AI.cpp"
echo "compile OK"

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
cp /tmp/nson_check "$WORKDIR/nson"
cd "$WORKDIR"

echo "== run scripted session =="
printf '5\n6\n1\nTestClass\n2\nTestProj\n3\ntestscript\n4\ntestpage\n6\n0\n' | ./nson > run.log 2>&1
echo "run exit 0"

check() {
  if ! grep -q "$1" run.log; then
    echo "FAIL: output missing: $1"
    exit 1
  fi
}
check "NSON ENGINE"
check "C++ class generated successfully"
check "C++ project generated successfully"
check "Python file generated successfully"
check "HTML page generated successfully"
check "NsonEngine shutting down"
echo "output checks OK"

for f in NsonOutput/TestClass/TestClass.h NsonOutput/TestClass/TestClass.cpp NsonOutput/TestProj/main.cpp NsonOutput/TestProj/CMakeLists.txt NsonOutput/TestProj/README.md NsonOutput/testscript.py NsonOutput/testpage.html; do
  [ -f "$f" ] || { echo "FAIL: missing generated file $f"; exit 1; }
done
grep -q "Hello from NsonEngine" NsonOutput/testpage.html || { echo "FAIL: greeting missing from generated page"; exit 1; }
echo "generated-file checks OK"

echo "== generated C++ project builds and runs =="
cmake -S NsonOutput/TestProj -B NsonOutput/TestProj/build > /dev/null 2>&1
cmake --build NsonOutput/TestProj/build > /dev/null 2>&1
NsonOutput/TestProj/build/TestProj | grep -q "Hello from NsonEngine generated code!" || { echo "FAIL: generated project output wrong"; exit 1; }
echo "generated project OK"

echo "== generated Python script runs =="
python3 NsonOutput/testscript.py | grep -q "Hello from NsonEngine generated code!" || { echo "FAIL: generated script output wrong"; exit 1; }
echo "generated script OK"

echo "ALL CHECKS PASSED"
