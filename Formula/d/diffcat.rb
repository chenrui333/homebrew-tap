class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "01261617c7e4b725da0ef28ec4a28036cb4f50e7aaf39caf02708624b7764c85"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5060095b1eaae98622115b54e58d2a7a35c7a28a21528e5490e105bbe589b851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5060095b1eaae98622115b54e58d2a7a35c7a28a21528e5490e105bbe589b851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5060095b1eaae98622115b54e58d2a7a35c7a28a21528e5490e105bbe589b851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e96d151a731dcd98d2bb2744847fa5f141baa30fe94647f55be2bed0d30fd9"
    sha256 cellar: :any,                 x86_64_linux:  "d626bf5cee86492e1d914c1da7189909293d8d113b9e72ad65ce16ed3d24f764"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    output = shell_output("#{bin}/diffcat not-a-real-command 2>&1", 1)
    assert_match "not a git repository", output
  end
end
