class Amux < Formula
  desc "TUI for easily running parallel coding agents"
  homepage "https://github.com/andyrewlee/amux"
  url "https://github.com/andyrewlee/amux/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "7cdc5f0ec1a9d47e3c3dc5bbe6fec95f766f7cd4ea619bc013acd00f073fe6b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34330f3037777d21dbff7fc99d2ebc5659bda88bff8926d012a3aa74093f3f61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34330f3037777d21dbff7fc99d2ebc5659bda88bff8926d012a3aa74093f3f61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34330f3037777d21dbff7fc99d2ebc5659bda88bff8926d012a3aa74093f3f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1eca0aac4c539b862483845103841e0e6bc2e5705b8b27ed36377df6e391b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddf7025d68c1e4a501dca7cda15d155f5eaf2d663634f0e389b48d004cd6c0b"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=Homebrew
      -X main.date=unknown
      -X github.com/andyrewlee/amux/internal/update.homebrewBuild=true
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"amux"), "./cmd/amux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"amux"} --version")

    output = shell_output("#{bin/"amux"} 2>&1", 1)
    assert_match "requires stdin, stdout, and stderr to be TTYs", output
  end
end
