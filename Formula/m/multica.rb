class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "efd7318ee895ee7649f4b1772b967410ca7f5af646a6c9473f349994ca54bb94"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f688b128bb88bc93c25566a5c57d40ec67d7687309a057edf5ef5939ace20b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f688b128bb88bc93c25566a5c57d40ec67d7687309a057edf5ef5939ace20b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f688b128bb88bc93c25566a5c57d40ec67d7687309a057edf5ef5939ace20b89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12bc1f3cde2df6f491fc821f0bbb8efb766a80834728437aaebaf8860bf5b839"
    sha256 cellar: :any,                 x86_64_linux:  "94a9bd27876857721a619708567fc2b8b3d67280db82cd0272e140338b9ed20a"
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
