class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "063ee3fdd6d5f4b16476d7b385ef1d4082140c803db0ec05c330ef77643202d3"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90f12833a1fc847375aaf8dd3b3af809eed66420d66e8f04727096fa1458b087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f12833a1fc847375aaf8dd3b3af809eed66420d66e8f04727096fa1458b087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f12833a1fc847375aaf8dd3b3af809eed66420d66e8f04727096fa1458b087"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6754aca20f1ed4747f98a447e0e9b19ffb188c23135944caa9a3876c11de136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def01752d5b56cfb96b9382ffb232772bc3071830debeb59ddd7817cf41310ed"
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
