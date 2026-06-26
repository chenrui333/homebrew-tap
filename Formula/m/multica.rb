class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "f9dbe76a625515ac9871f393ba1ee9392c8985f8cfc2d1c2a5543cdf70da44f8"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7b4ed10c485398b9057c9406c121ad9f365272f2e30b4802cc5a3764f093fcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7b4ed10c485398b9057c9406c121ad9f365272f2e30b4802cc5a3764f093fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7b4ed10c485398b9057c9406c121ad9f365272f2e30b4802cc5a3764f093fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe70bd79d868f859b95f7e82a3f12e66d61eddd0da19bd03e4fc874c4e3a3e9"
    sha256 cellar: :any,                 x86_64_linux:  "1d41a0a62e460b6425a65dc34d6e6801abf6b6385389584515e087856c3719d8"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")
  end
end
