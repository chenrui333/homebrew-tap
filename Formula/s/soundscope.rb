class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "eb1cc8657edf20344823909179b7416ba026c8c27cf5aad2bee1b689573e6b73"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "de4f9b53afc24c01f9d0bfcd240d90ff94369230de6a136d977e8a4f2d2d4b79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f51e386397b0995febf2d72346d829eee4cf16bf8b8db84bbc0c5447a2fde5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f36bd9e338216d4313ad7e0a49c52cc1921730c1a7657a22d04e35735235a7"
    sha256 cellar: :any,                 arm64_linux:   "9e84adb1d563c644cce24ecf8b7817a517ed5225b094ced13a2874f73eb53c8a"
    sha256 cellar: :any,                 x86_64_linux:  "fd1c1e129573aa6122134299ea0b4074d4dde5b0c3b39192f148eded8005e49e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soundscope --version")

    # FIXME: Upstream requires a working audio input device before it starts the TUI,
    # so a functional runtime test is not deterministic in headless CI.
  end
end
