class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "efd7318ee895ee7649f4b1772b967410ca7f5af646a6c9473f349994ca54bb94"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b627e1aed4f793918ba5b30f79750e0c5c0d0037610cdf4a43d06fafe13b99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0b627e1aed4f793918ba5b30f79750e0c5c0d0037610cdf4a43d06fafe13b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b627e1aed4f793918ba5b30f79750e0c5c0d0037610cdf4a43d06fafe13b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bfaa7f6bce357bb66a6d693c073f4eaed0642e1777eeb6d37c22edf1a59c909"
    sha256 cellar: :any,                 x86_64_linux:  "a41931bab74d48d289442dc40ef3fdf168d421135915d0b2fa75a2f6aeae2ab1"
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

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match "server_url:   https://example.com", shell_output("#{bin}/multica config show")
  end
end
