#!/bin/sh
set -e # Exit immediately when any command fails

# Install Rust.
#rustup -V || curl https://sh.rustup.rs -sSf | sh
#. $HOME/.cargo/env

# Build multitime.
#git clone https://github.com/ltratt/multitime.git
#cd multitime
# make -f Makefile.bootstrap
#./configure
#make
#cd -

python3 run_benchmarks.py --multitime ./multitime/multitime --rust ./rust --clif ../rustc_codegen_cranelift --template template.tex --benchmarks ./benchmarks
