class Kctx < Formula
  desc "Kubernetes context engine for humans and AI agents"
  homepage "https://github.com/lucasepe/kctx"
  url "https://github.com/lucasepe/kctx/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "34b9892f3d66514322ece2a0f586f146dc8bbe6a7e58665abb7f9717f928de53"
  license "Apache-2.0"
  head "https://github.com/lucasepe/kctx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a240a39b8132ed994366ff7cbdf3b6828afd31cf8c8b110d1272213fcd027d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a240a39b8132ed994366ff7cbdf3b6828afd31cf8c8b110d1272213fcd027d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a240a39b8132ed994366ff7cbdf3b6828afd31cf8c8b110d1272213fcd027d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68592bddbd75a95fa9ecb7978aae912b65a7ab3a8f3ba69cdbbe38fd909c2721"
    sha256 cellar: :any,                 x86_64_linux:  "9502777760cd54a45affe115295f87d8bb3a8f8ebf61648eeb0e1a3ef08414ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/kctx 2>&1")
    assert_match version.to_s, output
    assert_match "dump", output
  end
end
