class Ffdash < Formula
  desc "Terminal UI for batch AV1 and VP9 video encoding"
  homepage "https://github.com/bcherb2/ffdash"
  url "https://github.com/bcherb2/ffdash/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "61d8ef2cdb3d6b232df25eb05b375b72245b51ce00b3ce072612dae53b7382eb"
  license "MIT"
  head "https://github.com/bcherb2/ffdash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63368018d6c60ef94a5e5507bceec8220d7168c037cece532a48fb8c142893f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1025b4e873c6f5082f7f2e8bc40bc562a1ff69b77112dfc1b7fed1975073dd94"
    sha256 cellar: :any,                 arm64_linux:   "0d38919b6c27518858834aae45f1a794414c5bce4b80db4f7723759fecbdb528"
    sha256 cellar: :any,                 x86_64_linux:  "6c00a2bf8d6ab100a2d4692859e2c73930780cfbc54607c6b2bc63080599c7cd"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/ffdash check-ffmpeg")
    assert_match "ffmpeg found", output
    assert_match "ffprobe found", output
  end
end
