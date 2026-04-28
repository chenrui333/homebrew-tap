class Bytebox < Formula
  desc "Standalone WebAssembly VM"
  homepage "https://github.com/rdunnington/bytebox"
  url "https://github.com/rdunnington/bytebox/archive/5931f4fa85b4a65d4edbb8810f8e767da1143e14.tar.gz"
  version "0.0.1"
  sha256 "ed8aba1339abf3cafb9fb923731b8a9edefad366623be45877677457a166d7aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ab35c42fbf80f3af7509c6ada34e53f3148d25e5962d2dbed4ebdf71dc2e6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd0f7ae57d3b63dda71f09f3ad38d6b558a9b4f7d3607b4ee317710cf61eb60"
    sha256 cellar: :any_skip_relocation, ventura:       "f058bf91d6666b5a0ef1e3487bfbbdc96a72b3c94929b0d0e8f245cac7e50435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f29f120ddbfbde9e6c139fd550c94c18ac5c9e8af0d58938b2fedc7453e82c3"
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
