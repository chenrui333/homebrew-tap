class Sig < Formula
  desc "Solana validator client implementation written in Zig"
  homepage "https://syndica.io/sig"
  # zig 0.13 pr, https://github.com/Syndica/sig/pull/166
  url "https://github.com/Syndica/sig/archive/5ddea9054ded6282af31a40d0313e8e13a72b3a7.tar.gz" # for zig 0.13.0
  version "0.2.0"
  sha256 "a8d71e20a06fe15dbbcecf9f430a8e02f30eedbeb19d966db568255b5c426f66"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ead51ac8096dcd2bf875b84e94a47ae7ceb21a1e35db38029e9cbfb64761b0"
  end

  depends_on "zig@0.13" => :build

  deny_network_access!

  def fetch
    configure_zig_sdk
    system "zig", "build", "--fetch"
    # `zig build --fetch` does not descend into dependencies' own build.zig.zon files.
    cache = Pathname(ENV.fetch("ZIG_GLOBAL_CACHE_DIR"))
    fetched = []
    loop do
      urls = cache.glob("p/*/build.zig.zon").flat_map { |zon| zon.read.scan(/\.url = "([^"]+)"/).flatten }
      urls = urls.uniq - fetched
      break if urls.empty?

      urls.each { |url| system "zig", "fetch", url }
      fetched += urls
    end
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
    assert_match version.to_s, shell_output("#{bin}/sig --help")
    # Identity: 5W9ZHG5hsp1UzQ47ANCWG6pDiD7LqyWetZhsZjwQTYX6
    assert_match(/Identity: \w{43}/, shell_output("#{bin}/sig identity 2>&1"))
  end
end
