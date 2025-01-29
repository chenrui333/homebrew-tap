class Bytebox < Formula
  desc "Standalone WebAssembly VM"
  homepage "https://github.com/rdunnington/bytebox"
  url "https://github.com/rdunnington/bytebox/archive/5931f4fa85b4a65d4edbb8810f8e767da1143e14.tar.gz"
  version "0.0.1"
  sha256 "ed8aba1339abf3cafb9fb923731b8a9edefad366623be45877677457a166d7aa"
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
