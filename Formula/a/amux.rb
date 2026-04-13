class Amux < Formula
  desc "TUI for easily running parallel coding agents"
  homepage "https://github.com/andyrewlee/amux"
  url "https://github.com/andyrewlee/amux/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "552b816b0efea41e55bbd92ba9568d71424c096f6b60fce5eb1ec04ebca9a46d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b4483f11172a6f994699598ffc499a7392a12848eabfc145db5d8e1425fa87b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4483f11172a6f994699598ffc499a7392a12848eabfc145db5d8e1425fa87b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b4483f11172a6f994699598ffc499a7392a12848eabfc145db5d8e1425fa87b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "532c117cfe58cc0f052ca942d50c398a2adcbe5cd4b688bf42a93cd90edf18db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a379493f654d6577e97361e0e43e2345746f4a5b13fa3bfbb008a1317e42a32c"
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
