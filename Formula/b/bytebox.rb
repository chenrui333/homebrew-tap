class Bytebox < Formula
  desc "Standalone WebAssembly VM"
  homepage "https://github.com/rdunnington/bytebox"
  url "https://github.com/rdunnington/bytebox/archive/5c8753ba11c394e4d642dddbb459edcd7c97ac26.tar.gz" # for zig 0.15.1
  version "0.0.1"
  sha256 "ed49be2d515765afde9716e9179485b524e9c53989048a9bfb9f416971664846"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1889675ffbdd7f515ea6053c915ab68163dba018c5ae4343aa9f1b2edfd83096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fca7f8a07d726e0dbc0d9ff5d1127ab782e19dd7c6b6cc83512d8b2afeba2c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1bedc6509fe3e4ea255c4573503c40a85af2bc41634dc22f1f22085b84d9b8e"
  end

  depends_on "zig" => :build
  depends_on "wabt" => :test

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args

    # remove non-executables in bin dir
    rm Dir[bin/"*.wasm"] # files are add-one.wasm, mandelbrot.wasm, fibonacci.wasm, memtest.wasm
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bytebox --version")

    (testpath/"test.wat").write <<~EOS
      (module
        (func $test (result i32)
          i32.const 1   ;; push literal 1
          i32.const 2   ;; push literal 2
          i32.add       ;; => 3
        )
        (export "test" (func $test))
      )
    EOS

    # Convert the .wat to .wasm
    system "wat2wasm", "test.wat", "-o", "test.wasm"

    output = shell_output("#{bin}/bytebox test.wasm -i test 2>&1")
    assert_match <<~EOS, output
      return:
        3 (i32)
    EOS
  end
end
