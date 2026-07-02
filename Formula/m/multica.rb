class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.35.tar.gz"
  sha256 "3b05ffb158a25dfdd3bf86966d901d5e77006bafa4a0d676a5d0a0f5c048d9c5"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "955aad16d9d3d790b419177fd44cb0899c6aeaab79c59738ffa6b0059d2760b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "955aad16d9d3d790b419177fd44cb0899c6aeaab79c59738ffa6b0059d2760b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "955aad16d9d3d790b419177fd44cb0899c6aeaab79c59738ffa6b0059d2760b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "567a8c0181df2a6b58d1f76f326e2d90725b0f2e4963f0a512b69af83dc152bb"
    sha256 cellar: :any,                 x86_64_linux:  "89b027cfab6eb95cca8d6052db0e01319d4b9f447c84677a0a1f89ef6b322e91"
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
