class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a25af47d5352daf32a9189aec19a0c02c7dab6ae779fc860dff15a27838297c2"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01045d17dffc3e3ce8a31f32da420390f1513ace7ecf2b5dc0aabedd9e375d73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01045d17dffc3e3ce8a31f32da420390f1513ace7ecf2b5dc0aabedd9e375d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01045d17dffc3e3ce8a31f32da420390f1513ace7ecf2b5dc0aabedd9e375d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83b81b739fe8ff0af2d7d3eed685a6bc997ba4bc2e184a8f0b52869cb97dab9"
    sha256 cellar: :any,                 x86_64_linux:  "56974b150a2345d16f39dbae4549a1d5ec4de25c61a33aceb5ec2ae551f2a24d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
