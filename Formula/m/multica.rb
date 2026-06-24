class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.29.tar.gz"
  sha256 "9a76287c194c5d8f6c7e4a9f161d736683e3a12554d483f355c939985d6fc317"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46edda0c3202b3a1388215a4243e50c071ffcfdaa54c8ba51658efb6dffd071b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46edda0c3202b3a1388215a4243e50c071ffcfdaa54c8ba51658efb6dffd071b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46edda0c3202b3a1388215a4243e50c071ffcfdaa54c8ba51658efb6dffd071b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc2e14e9b58c3e74188202c73f0b0440e2a3f389e3efdeef2baa9b321808f9b"
    sha256 cellar: :any,                 x86_64_linux:  "4798add6cb82ada9b7a1ee19bc4d8bcd7809c4e11c94d8701fc1b74378db5064"
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
