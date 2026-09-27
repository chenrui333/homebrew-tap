class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "4d68a3573c732c133fd8390187c61c03d78882779818df8c7ad9e5b968dc11a2"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f30c3ff7af6fb72fbd9611b7993e084736852174003d4eb112822ae6175a482e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30c3ff7af6fb72fbd9611b7993e084736852174003d4eb112822ae6175a482e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4d4e7a684e41ef29af963d821acaadb6b64d5cd33d1cb67061ab4704ba444e"
    sha256 cellar: :any,                 x86_64_linux:  "33082e7ba035f000e39bc735b4a0b4c980859dcd7c1802d0e1e7edfc32fb0775"
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
