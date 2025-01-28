class Wisp < Formula
  desc "Lisp in WebAssembly"
  homepage "https://github.com/mbrock/wisp"
  url "https://github.com/mbrock/wisp.git",
      revision: "42753529b26ebd579390cddb77f876e17a4b6089"
  version "0.8.0"
  sha256 "6fa80325c9bf7d0641a3136b26b90af7d532dc1e2ece928200c9eb270a5a248a"
  license "MIT"

  depends_on "zig" => :build

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

    # wisp is in core dir
    cd "core" do
      system "zig", "build", *args
    end
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
