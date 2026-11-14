class Steamfetch < Formula
  desc "Display Steam stats in the terminal"
  homepage "https://github.com/unhappychoice/steamfetch"
  url "https://github.com/unhappychoice/steamfetch/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "cd8184c8b1c0c53b5d2d4ff99e08a0cef778de641bb75ae6fa0d8dac4178dc66"
  license "ISC"
  head "https://github.com/unhappychoice/steamfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "2be62096160a42b90771486884d48fb5b05b52a23dd1c06b2c07b90b8889ad66"
    sha256 cellar: :any, arm64_sequoia: "16d26d098c19c9240c589ce96d26d2fd3b2b3eee67b0b89f4f19257e91a8dbd5"
    sha256 cellar: :any, x86_64_linux:  "feac4f10c52cb6c6f92507e057758c3474ff08d7bc722646e7dfb7b8b34abe7e"
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
