class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "41727bc30e1352caf3ce9a053e251693166ab684321fa5fda8a4588de1333435"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc42eda3d90a0ce879f660f29cea423d2ca490870eca919ae418982e27fc127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c2b5452a9a14ae18001ce104436e2b5718e54b34334b8d5fe571b5ea716ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8cdf4c28bba5af0ffd68f77e30fe27f0c095747d62108f2c5caedf7298382a3"
    sha256 cellar: :any,                 arm64_linux:   "492b5dae30333ab81897d7421d7d63821ed8cdd0400e04081f6946db63b368ac"
    sha256 cellar: :any,                 x86_64_linux:  "130110e796e460b67ea3bd8e3fff45c71faafe6961593d2d037ec311b3349ec2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
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
