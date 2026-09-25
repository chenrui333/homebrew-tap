class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "debd25890c82274db77f654a8785d1827ed6ac93a3c450863a1ef844821377f2"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb0533ad6f58c907aeb373e8400aaf8f45a4b9bae85c3e90ae4453634d8776a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0533ad6f58c907aeb373e8400aaf8f45a4b9bae85c3e90ae4453634d8776a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02b30ea16000a5ed76d234b058df7d72ced45d0d9988ef7daff3f730714b8f17"
    sha256 cellar: :any,                 x86_64_linux:  "bb12f8367ead4651467c296a3749a0842b7bddac9e54ab1bda1c08e7c644392b"
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
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
