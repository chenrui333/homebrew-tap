class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "915d91634b167a93e715d22e7346d50fdc5d8f8d7ec08eb96bc5bf25d855fb37"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c220314df89cf352583f71d8e2e120a48bf5f082333de5657e21fc5dc8fff8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c220314df89cf352583f71d8e2e120a48bf5f082333de5657e21fc5dc8fff8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3450e336c411b8872afd1552eebb27708482fafd9f432c08721db51e833f333"
    sha256 cellar: :any,                 x86_64_linux:  "d9077a9cb36c5951045cffce30b890d41fe24b43b3df698f2e987765a5ce706b"
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
