class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "72388c58066c2db903414c31c94f1530f7bad4e6ce91a394e297a32821a15022"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c5a3c5ac800456f354e4be9eede408982c06768ef11715d4940e099885be9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3275d96b9d7802cc8e135b4baa335ca0a5a0b2603b7d140950de3f7620f34e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5859a48e5bcc02fa27a7905d5b3b1fc07d96cb8fb757f2c2af3f753efa7c93"
    sha256 cellar: :any,                 arm64_linux:   "fa776003d4e7d7fe39e659a7333450c64d3b7ff4f1beadf93a60594e4767d91b"
    sha256 cellar: :any,                 x86_64_linux:  "3b1acb9f29138a689c01ba59bf1092a1340ea47c2fdc3338c010d7bf0c4813bf"
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
