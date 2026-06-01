class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "320dd5d1bb96ed8914a1937c3706d873e4b16e6f734830e180fbbe4e9c7de898"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2ce139c5976ebd39704807003c42d19a2cb4beb1d60d6b40d41bf3924fbbf2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ce139c5976ebd39704807003c42d19a2cb4beb1d60d6b40d41bf3924fbbf2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ce139c5976ebd39704807003c42d19a2cb4beb1d60d6b40d41bf3924fbbf2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ddddb50d4997de7d14176e652b4364945fc121adf5894ed8948cdd39c44e6ac"
    sha256 cellar: :any,                 x86_64_linux:  "fbdf3df7cdaba66b287a5dc5920d5306859b7d7764bcffb8bdabe55d85561dc4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
