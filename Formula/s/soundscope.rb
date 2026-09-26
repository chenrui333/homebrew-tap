class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "41727bc30e1352caf3ce9a053e251693166ab684321fa5fda8a4588de1333435"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "173088edc35d44fd2d58d7ca0d2de1eabb134cda70eac27b2b4e707e445b49ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265d5edd5369da03bff8dc8dc60a2a90fd9312343b76002c42efff5d88770453"
    sha256 cellar: :any,                 arm64_linux:   "bf78373004c3438a7cdee4eeea39a98b96681cd2ea1aea689bcb8efc0b967da6"
    sha256 cellar: :any,                 x86_64_linux:  "17877e43306a933d19f3e334fb7bd4850bbf857e7560ea62a5937c0542b7e799"
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
