class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "a8991a6276d62ad9c513253e6cdb27300c51bc78757a2aa141fe8975d0dfaea7"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816c5c66ff7b43269474e9e927674fbf3fc999c53605f030ee4a12caf4a5a1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "132e925cf0f1e35fb0e6f801459f8a121848892201eded154c554f1cc38fcec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1d74c3fece3b2e1952ebd61e6633ecc7e2974e102cea842608a6cd0c821f3c"
    sha256 cellar: :any,                 arm64_linux:   "1d6ae2678eb75ad0a63770c8f5faa12f36d66f7c5c86e9efc989c6a79c7ee3db"
    sha256 cellar: :any,                 x86_64_linux:  "78fb7de78bdab213b6f01fdbf77623224e6633d306c332a1b435641d6178c957"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comchan --version")

    shell_output("#{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
