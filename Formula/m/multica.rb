class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "9358a25c00744cf6010afd3520faec759ba70eca92df8425c82865de7c2c2b24"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "866023512abed19dbd6845a2799ca7e19a29e0727d11a7cd5364766423f1a5de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866023512abed19dbd6845a2799ca7e19a29e0727d11a7cd5364766423f1a5de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866023512abed19dbd6845a2799ca7e19a29e0727d11a7cd5364766423f1a5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39c9c5585267e02a41111c0775208f52f4f6ab7c87183bacd0c250bfcfa90a3e"
    sha256 cellar: :any,                 x86_64_linux:  "a7c7b5283df0a31d91ba8e0d60c379faaffee7fb33efc17d75037d0f96e33880"
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
