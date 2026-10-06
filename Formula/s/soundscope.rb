class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "41727bc30e1352caf3ce9a053e251693166ab684321fa5fda8a4588de1333435"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "725a931bd620a641d08bcd8033a6271fc92234a725537d3cdae4f99b8bc250cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6ff717d5a3882ecd16414fb96c6b2a37f9c50b8c9b45a194cd2f44353d4481f"
    sha256 cellar: :any,                 arm64_linux:   "fb75edccc9aebe01bf41ad918c5131df04ec2b0f0ffaa7006a635ccf7a1be0ec"
    sha256 cellar: :any,                 x86_64_linux:  "47a1e109c2a17c08da48a214bf61652f7a6d1a6534a91b9d7a60f78fd6370b2e"
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
