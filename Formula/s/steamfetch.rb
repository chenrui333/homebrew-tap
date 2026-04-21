class Steamfetch < Formula
  desc "Display Steam stats in the terminal"
  homepage "https://github.com/unhappychoice/steamfetch"
  url "https://github.com/unhappychoice/steamfetch/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "9726d9675cac0ca7336d64d53f550a7271c184d10be59e65b7a205a7f2ccc3a3"
  license "ISC"
  head "https://github.com/unhappychoice/steamfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0de60fe4d38d4ed66b9d17424aa7c1b9a0dc5bd15305f4e06bb0fbb2e8b68ec4"
    sha256                               arm64_sequoia: "d19e95e4b14754b2a41bfb647cc9df50f4bb908348fd592bf300fddea59cd5e4"
    sha256                               arm64_sonoma:  "9b8ea23671ff00b1ffe2c9ff71e4acf5870f5492ef3c65e8b1e3f585081e02bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ba60b06b8780a26dd12114d4ef9514c38f70868e518d87a39635ac615cf1996"
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
