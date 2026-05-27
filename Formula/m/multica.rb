class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "be147b59d9f3202f6ffd632d3163ec41ab55f6ecabe37ddd696311d4609b5a6a"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b18772293cde24bc3aa526992f87713f25b63e73d8e9f28792b6b03d50e0f5e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18772293cde24bc3aa526992f87713f25b63e73d8e9f28792b6b03d50e0f5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b18772293cde24bc3aa526992f87713f25b63e73d8e9f28792b6b03d50e0f5e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eebff0084b47651ccfa9465c08d922196df72600e93a443137205b5ccccfefac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f62224dc7a12f5ac135de49e879dbfc18feeb461b882cb110edee60dab0dd01"
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
