class Zware < Formula
  desc "Zig WebAssembly Runtime Engine"
  homepage "https://github.com/malcolmstill/zware"
  url "https://github.com/malcolmstill/zware/archive/3ad3f4e10bafba1d927847720aacad78f690cec6.tar.gz"
  version "0.0.1"
  sha256 "7135b821013c1a94631865ab300daf2291c6fd0e96a76b3e70c1ea09cf4a8379"
  license "MIT"

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
  end

  test do
    assert_path_exists lib/"libzware.a", "libzware.a should be installed"

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

    output = shell_output("#{bin}/zware-run test.wasm test 2>&1")
    assert_equal <<~EOS, output
      info: 1 output(s)
      info: output 0 (I32) 3
    EOS
  end
end
