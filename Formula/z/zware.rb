class Zware < Formula
  desc "Zig WebAssembly Runtime Engine"
  homepage "https://github.com/malcolmstill/zware"
  url "https://github.com/malcolmstill/zware/archive/3ad3f4e10bafba1d927847720aacad78f690cec6.tar.gz"
  version "0.0.1"
  sha256 "7135b821013c1a94631865ab300daf2291c6fd0e96a76b3e70c1ea09cf4a8379"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e119dd63a9a5a990693319e1e705b989fe603889e81b64c2403eee8b3db7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6549026db4f8c498a7ddadc30b588b3e7d6baa6c2feb2eda8d2ff21f61e9ee"
  end

  depends_on "zig@0.13" => :build
  depends_on "wabt" => :test

  deny_network_access!

  def fetch
    configure_zig_sdk
    system "zig", "build", "--fetch"
  end

  def install
    configure_zig_sdk
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

  def configure_zig_sdk
    on_macos do
      developer_dir = buildpath/"CommandLineTools"
      (developer_dir/"SDKs").mkpath
      (developer_dir/"usr").make_symlink "#{MacOS::CLT::PKG_PATH}/usr" unless (developer_dir/"usr").exist?
      ENV["DEVELOPER_DIR"] = developer_dir.to_s
      ENV["HOMEBREW_DEVELOPER_DIR"] = developer_dir.to_s
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
