class Steamfetch < Formula
  desc "Display Steam stats in the terminal"
  homepage "https://github.com/unhappychoice/steamfetch"
  url "https://github.com/unhappychoice/steamfetch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "73506a78d60215b2ed32afd4634d5549e4e316e57c0f87fd31724a568138f928"
  license "ISC"
  head "https://github.com/unhappychoice/steamfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "2fb66e5f8ed132b171f31433dd996d4be077f7ab38aea15fc04851d5d2d2e9cf"
    sha256                               arm64_sequoia: "9445b7b23177ec60708f59f506bc5749bb8f49b26a12a01a4662517e9b599d04"
    sha256                               arm64_sonoma:  "cab1b62189e8aa2aa47bc0c99b56b0ea8ecc534d2608b29025bea6b214beb3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b6707595253022bc9864730dd35053b752ffe7cffd2bd3b7075337636bb01f"
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
