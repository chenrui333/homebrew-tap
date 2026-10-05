class Lola < Formula
  desc "Programming language meant to be embedded into games"
  homepage "https://lola.random-projects.net/"
  url "https://github.com/ikskuh/LoLa/archive/fddcc3a04e759fa8a1f639eb5f86041a40dcb231.tar.gz" # for zig 0.13.0
  version "0.1"
  sha256 "ae996b9ca3137537dabe42926f61e1fa88a73315dab4c9b6d4469d1eeb242430"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686dddda68882349edee8d034f4e41d6b993e9be52224fcbff363fa0adf2fd98"
  end

  depends_on "zig@0.13" => :build

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

    # remove non-executable files in bin dir
    rm bin/"lola.wasm"
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
    (testpath/"test.lola").write <<~EOS
      var list = [ "Hello", "World" ];
      for(text in list) {
        Print(text);
      }
    EOS

    assert_match <<~EOS, shell_output("#{bin}/lola run #{testpath}/test.lola")
      Hello
      World
    EOS
  end
end
