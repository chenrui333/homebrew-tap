class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "c07875dabd644d622ef073a5f650f50f4f6ffd9a217bcab8b9e7b98cca15c7da"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f5d03dd8e2f6d00d4cd81da069068f248917737a1c9e01fa60f1b0e0b40e39d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5d03dd8e2f6d00d4cd81da069068f248917737a1c9e01fa60f1b0e0b40e39d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e378ed7064ad84d7a34ae9d874b27804f163133b37c1adcac3e79b40f238a17"
    sha256 cellar: :any,                 x86_64_linux:  "3d16f8e4c766ff7756489261573b122c3434cc59bc5767009c96b7ccf58915f3"
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
