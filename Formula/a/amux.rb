class Amux < Formula
  desc "TUI for easily running parallel coding agents"
  homepage "https://github.com/andyrewlee/amux"
  url "https://github.com/andyrewlee/amux/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "552b816b0efea41e55bbd92ba9568d71424c096f6b60fce5eb1ec04ebca9a46d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "112db4efb370a625236f5c5b48f3bc24219d24f46b6e7c969f6c4ba19f6c83be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "112db4efb370a625236f5c5b48f3bc24219d24f46b6e7c969f6c4ba19f6c83be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "112db4efb370a625236f5c5b48f3bc24219d24f46b6e7c969f6c4ba19f6c83be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa1bedadc53a0f70ee83a04b7a32fef6f2f8d43361058b11e21759c4b472b709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6873002ea8c98b0452881d639ca806f5a26a74421118512c05b81f6385bda4d"
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
