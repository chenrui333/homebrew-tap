class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f66667621b7251a92803633e6c2b18747b32a45a04d0d0e892e6483c5e65ea86"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b29ff2eddfa3dc2fd77081a235b3625d6413a91c1ae73697d8d2dcb6724d811a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcee11c6737bd46f7c56fd4c9e3fba9e0d27a3fabf0e2a7af9990439be2c40a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ff0e40856c01edefbedf3a637e1aba0b4b655d1da2ef39f2a80ce8f85b83e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c2ae7d92fd77bffd7c08035bc4bd3ff452158868af6e7f68ee9c9a868fdbdd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f163a12bc16a74f7c5c7c9b46781a193d84777cdf2e4ead767fd96be38d57b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comchan --version")

    shell_output("HOME=#{testpath} #{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
