# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d06648feb9d0da53f10188f050e8324162a1a83a1ed0f2f7a360983dc2f2b0a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93a5c39ca77882636d1159c862a57d4940911558e793df28332c6323dc59a8c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8ab5bdfab104763bf03d89c389e3b393d2f9d07df11cdd7af849cfbec8596e2"
    sha256 cellar: :any,                 arm64_linux:   "f20de899a939feed57c7c4a95f50915b0db07d13a3b5038d9d9152f3eefd22b8"
    sha256 cellar: :any,                 x86_64_linux:  "d4d0e8c7710fe86319f1aa8ce18de324428f4a6682ac8bfe8d0d4872925c6b90"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tickrs --version")
    output = shell_output("#{bin}/tickrs --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
