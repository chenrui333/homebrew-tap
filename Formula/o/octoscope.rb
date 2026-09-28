class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "d4c284308b6d52160349dacd992a3688f7f167c03f125906d0937b5ad0a5f8a1"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335c6cd10243bcfa0326b37f10cf02264c56aef78d94cffb4ae7b02e443b3f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335c6cd10243bcfa0326b37f10cf02264c56aef78d94cffb4ae7b02e443b3f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6650d03143b52ab1e0a1ca56d87715b74551c9a5bec956a6a6f60aba7d9b06"
    sha256 cellar: :any,                 x86_64_linux:  "84632fe9010f21b51cae8822252d6c061ee51e2bcd49cd5b4e0d6b68831e3ece"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
