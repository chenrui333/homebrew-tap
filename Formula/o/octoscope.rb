class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "c41c3c52fff2dab2f691d99f91beef17911b561c8fe823a8c9e2f34616ff0f7d"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "752085651801c024f05e5144df72e9ca8e318c25158fedbba028b5e38111523c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "752085651801c024f05e5144df72e9ca8e318c25158fedbba028b5e38111523c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cce6c5c95848d0534a26d8b1e59054acb804efa6aff74ae48cc4f316578eb9c"
    sha256 cellar: :any,                 x86_64_linux:  "eda189edfb94f16e3cbc7ff0b03f519ac53dc83e92aa2f3ab50ca6a8914f3377"
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
