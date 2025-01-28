class Zware < Formula
  desc "Zig WebAssembly Runtime Engine"
  homepage "https://github.com/malcolmstill/zware"
  url "https://github.com/malcolmstill/zware/archive/3ad3f4e10bafba1d927847720aacad78f690cec6.tar.gz"
  version "0.0.1"
  sha256 "7135b821013c1a94631865ab300daf2291c6fd0e96a76b3e70c1ea09cf4a8379"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "334ba0e2221a5899f492ab229b242539cab9aa3c3b4dbca912691e291d081e0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9fbda903ba869eec33d5439446279e79aec3f62e8b255efa889aac839d69b0c"
    sha256 cellar: :any_skip_relocation, ventura:       "43733c5ca07c347a65c685278fea324ac2a40b2d0ca58cab521de8c5304628c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3a72d915d1a59d9fb85e678e94a13b4aa291469027297fe3d86adfc5644db2"
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
