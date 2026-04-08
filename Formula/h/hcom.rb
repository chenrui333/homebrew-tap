class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "36e12e039481d9f739892130dda4dc889ddf9cb0da46d32c11a250f8c7f43195"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3abbcf28ce9eb09b08c6c9d1ce658fc206eb59e49ab41461a093b0b2fb2b51a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ef8b30b9277e2841502935fae47bb2d75ce2a35200d8e1bb6f5cd4e7328d55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a2bbde131d6c74428af0521827e8b51aa039c9bac6523f6acfb1b88b23e2e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610077ddec1a4252b0951c598549f3354651e74bbffe060c14cfb3a8850f1f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45cbb0cd191058cd0e00e9f7530a79ffe4b4c4f8503473fa3f497a9f22ffdf75"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
