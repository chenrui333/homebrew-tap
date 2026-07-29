class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "27b9133d8933c92cf73973c592fff231649580baa277639d900f6e6bb2ab42ab"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77d6f9df30ae198e6b70fa193a7b12058a4a65340b9a88ae078d33c4bb8761b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d6f9df30ae198e6b70fa193a7b12058a4a65340b9a88ae078d33c4bb8761b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d6f9df30ae198e6b70fa193a7b12058a4a65340b9a88ae078d33c4bb8761b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b401065f14869f545c97c4ddbb8e95a39c384dd1b48c5e38c2a5b84f09833d02"
    sha256 cellar: :any,                 x86_64_linux:  "dc89393ab22f77d2559ef6cea527ac075cf81b46448b2be9941fbec310d3bc79"
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
