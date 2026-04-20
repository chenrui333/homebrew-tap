class Steamfetch < Formula
  desc "Display Steam stats in the terminal"
  homepage "https://github.com/unhappychoice/steamfetch"
  url "https://github.com/unhappychoice/steamfetch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "73506a78d60215b2ed32afd4634d5549e4e316e57c0f87fd31724a568138f928"
  license "ISC"
  head "https://github.com/unhappychoice/steamfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4356e5c8757a8070b104d07e81eb4a978b7b2c14e3ba096f54d626ee8f72f320"
    sha256 cellar: :any,                 arm64_sequoia: "4042fd4bbb0a21a95ac04801af5af87297dd46134dbebc0fd95c27f0e7135868"
    sha256 cellar: :any,                 arm64_sonoma:  "032edb81b115bfd38f64a4ce0c387b608378d2ec0ad43ff2a4a627a5657fa13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc89f106fed5ace2a30a9f46b496b60296abaeecaa47e6dbb328a69376c6460"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on arch: :x86_64 # steamworks 0.12.2 fails to build on Linux arm64
    depends_on "openssl@3"
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
