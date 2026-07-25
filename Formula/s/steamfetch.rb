class Steamfetch < Formula
  desc "Display Steam stats in the terminal"
  homepage "https://github.com/unhappychoice/steamfetch"
  url "https://github.com/unhappychoice/steamfetch/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "2eb0829e97fc1fe1535fd076c1071b6dbe63d082c51475ca4b9a61b46687c2c5"
  license "ISC"
  head "https://github.com/unhappychoice/steamfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "61c1381291b528bf1355b2f971e8837d44e4b14a8d280fc690237859b6ed295a"
    sha256               arm64_sequoia: "9c9b59c63b7cabd4a6798eebd103f76319ffbc6c449664c0092e1cf87f15db55"
    sha256               arm64_sonoma:  "cd388347073f35c456c4f387eadadb92351fc831e92f7865492b2bff7613320c"
    sha256 cellar: :any, x86_64_linux:  "9d0649fe67f84c1d8f9f13721db059c454d28037b875193795b15f09a2b1b9c5"
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
