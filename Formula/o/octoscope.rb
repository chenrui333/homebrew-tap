class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.41.3.tar.gz"
  sha256 "2fac2ed11fd897fa1310cd939763a615fb876ba6c3d6cdb16bc755db83723610"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e77c4c04e62485ab53da66dbb4da415697da4314c563b9aaa211acd03be376d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c24aa67349406527a119c0fdf24a6a767e871f347a21a68301bec1bc1eb4c443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c24aa67349406527a119c0fdf24a6a767e871f347a21a68301bec1bc1eb4c443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaccbd8281b6cf79052a3c4e3fb29f5bd54ebf5949f29024b6f81bce31d844b2"
    sha256 cellar: :any,                 x86_64_linux:  "7c750b676f90fb953ce400a8cd287c400237d6e2b70d52a1e8d3fa12c62710dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output

    ENV["NO_COLOR"] = "1"
    assert_match(/Available themes:.*high-contrast.*phosphor/m, shell_output("#{bin}/octoscope --theme list"))
  end
end
