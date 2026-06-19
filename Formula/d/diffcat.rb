class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "10606e705ac9671fe03be9b3be4f875c9ab39db1a19352934903989fe9e2ecac"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "349f3479a4760f55bae351ec3720be62488587e9e08696c05686bd01454148c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349f3479a4760f55bae351ec3720be62488587e9e08696c05686bd01454148c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349f3479a4760f55bae351ec3720be62488587e9e08696c05686bd01454148c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7357811cf85b81178f1de13320af2781e35add3874e9673f6b8b06d6bc20826f"
    sha256 cellar: :any,                 x86_64_linux:  "bf87c27b8575adc3f332f40c713c07ba2ffb943282856042a68af77573e761ca"
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
