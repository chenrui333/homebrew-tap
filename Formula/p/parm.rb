class Parm < Formula
  desc "Cross-platform package manager for GitHub Releases"
  homepage "https://github.com/alxrw/parm"
  url "https://github.com/alxrw/parm/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "04c782bd4d12410314720bc40fa91410447d1176270c2eed425cc677d138facd"
  license "GPL-3.0-only"
  head "https://github.com/alxrw/parm.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e50be298202b624738d5ebe6f25fa275d22ebf029c68ed2cbe4082a68e543ed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77c77675ba72fda0671b750fcb71aab81aaa0ca2d119848589cb96129261092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685e703ca5890063801fee44d4eafa3d4fdbc21b5230a38675897761a66c09a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "988d9ee21e894a804edb30e3805ef9ec7aa036a671d3180ddc552fa8a486a479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9750e08e56e93f6c45e5d85947a47a11a105bc4bd771e2d38ef207d9b763300b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X parm/parmver.StringVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/parm --version")
    assert_match "Total: 0 packages installed.", shell_output("#{bin}/parm list")
  end
end
