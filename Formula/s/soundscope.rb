class Soundscope < Formula
  desc "TUI app for analyzing audio data such as frequencies and loudness (LUFS)"
  homepage "https://github.com/bananaofhappiness/soundscope"
  url "https://github.com/bananaofhappiness/soundscope/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "81c719dd319bd4c7910fc616404f9f14d33780206f743276b063e0045db0078f"
  license "MIT"
  head "https://github.com/bananaofhappiness/soundscope.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1b086173a522a444f56407ed4606a57b65bb36479a074f70dc3d3fc7efa4f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c4648edfd3fb19c23a979241e9ef8618fb4d367494286077620bf480cb75441"
    sha256 cellar: :any,                 arm64_linux:   "0d24a19263906479cc76543a48682985f7ce411d55471c913740c1d5a9a04191"
    sha256 cellar: :any,                 x86_64_linux:  "20b59f75b29dc563f1495ed2aa223db482ad0830d127b32c2a0420ad29a68e30"
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
