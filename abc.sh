#!/bin/bash

set -e

hyperfine --version || cargo install hyperfine

export RUSTFLAGS="-Cpanic=abort -Zcodegen-backend=$(pwd)/../rustc_codegen_cranelift/target/release/librustc_codegen_cranelift.dylib --sysroot $(pwd)/../rustc_codegen_cranelift/build_sysroot/sysroot"

for benchmark in $(ls benchmarks/ | grep -v repeated | grep abc); do
echo "[RUN]" $benchmark

pushd benchmarks/$benchmark >/dev/null

(cargo clean; cargo +nightly build) 2>&1 >/dev/null
cp target/debug/$benchmark ${benchmark}-clif
(cargo clean; RUSTFLAGS= cargo +nightly build) 2>&1 >/dev/null
cp target/debug/$benchmark ${benchmark}-llvm

hyperfine "./${benchmark}-clif" "./${benchmark}-llvm"

rm ${benchmark}-clif ${benchmark}-llvm

popd >/dev/null

echo
done

for benchmark in $(ls benchmarks | grep repeated); do
echo "[BUILD]" $benchmark

pushd benchmarks/$benchmark >/dev/null
hyperfine --prepare "cargo +nightly clean" --show-output "cargo +nightly build --verbose" "RUSTFLAGS= cargo +nightly build"
popd >/dev/null

echo
done
