class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "5fd7deb53f9bf02ddd61997d698a0f0579638a6e36df15c0efcbe2999dc204c6"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5bade94e72b4bea819e87e29dd58ec92fe1106661ec244cf799079a292d4996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5bade94e72b4bea819e87e29dd58ec92fe1106661ec244cf799079a292d4996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ddcb4acfe559f2730a08bd22bcd4fa6022e4d3db61121ccc8a16139d3eecf9"
    sha256 cellar: :any,                 x86_64_linux:  "81aa1b442bcad7982248aa58f7b9820b6e0f7972b5d515dfd56429d7f7df7622"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output

    ENV["NO_COLOR"] = "1"
    assert_match(/Available themes:.*high-contrast.*phosphor/m, shell_output("#{bin}/octoscope --theme list"))
  end
end
