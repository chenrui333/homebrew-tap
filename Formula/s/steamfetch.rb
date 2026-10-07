class Steamfetch < Formula
  desc "Display Steam stats in the terminal"
  homepage "https://github.com/unhappychoice/steamfetch"
  url "https://github.com/unhappychoice/steamfetch/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "2eb0829e97fc1fe1535fd076c1071b6dbe63d082c51475ca4b9a61b46687c2c5"
  license "ISC"
  head "https://github.com/unhappychoice/steamfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5c193f966438c12916552e85d2a6d3c4bf969c0d8fa2d8cdd9831b8a8ab765e2"
    sha256 cellar: :any, arm64_sequoia: "cd266d32afcc6eb9ab59e9a2f2298f43a7749d7c5da824d7c2a363b20129516f"
    sha256 cellar: :any, x86_64_linux:  "7f8fe4ed2074c4749eac28cc3cdeac53e4ca23901ef6badfaf14e8a4876ef381"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on arch: :x86_64 # steamworks 0.12.2 fails to build on Linux arm64
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    steam_api = Dir["target/release/build/steamworks-sys-*/out/libsteam_api.*"].first
    raise "libsteam_api artifact not found" if steam_api.nil?

    (lib/"steamfetch").install steam_api

    if OS.mac?
      MachO::Tools.change_dylib_id(
        "#{lib}/steamfetch/libsteam_api.dylib",
        "@rpath/libsteam_api.dylib",
      )
      MachO::Tools.change_install_name(
        bin/"steamfetch",
        "@loader_path/libsteam_api.dylib",
        "@rpath/libsteam_api.dylib",
      )
      system "/usr/bin/codesign", "-f", "-s", "-", bin/"steamfetch"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"steamfetch"} --version")

    ENV["NO_COLOR"] = "1"
    output = shell_output("#{bin/"steamfetch"} --demo")
    assert_match "unhappychoice", output
  end
end
