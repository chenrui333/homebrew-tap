class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "e9615bf8c11c0100c71938d674e22f0743f869c2ef2288a556d0be00c5018b74"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05e00d8ffa1f3a55d6b5696b540c80268a1b15e1f62910e908025da4ef0ff960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05e00d8ffa1f3a55d6b5696b540c80268a1b15e1f62910e908025da4ef0ff960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05e00d8ffa1f3a55d6b5696b540c80268a1b15e1f62910e908025da4ef0ff960"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c4695cf8ed1274574503a352efc2a567ac99e7b4db8bce8b36468ce2dcaf722"
    sha256 cellar: :any,                 x86_64_linux:  "2971e2a0410663cf017c46c6fa0de864ce72d7a32f884d6f42b76a58e82f1d03"
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
