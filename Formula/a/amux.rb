class Amux < Formula
  desc "TUI for easily running parallel coding agents"
  homepage "https://github.com/andyrewlee/amux"
  url "https://github.com/andyrewlee/amux/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "32a864d2b9a8b73f0bae347e35ba174e123f928358c99321d29466373b987262"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "020ffd78c0a064b2b2b4b1607bdcfe883bb587689f4c58fe99fc548db138ee70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020ffd78c0a064b2b2b4b1607bdcfe883bb587689f4c58fe99fc548db138ee70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020ffd78c0a064b2b2b4b1607bdcfe883bb587689f4c58fe99fc548db138ee70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc201bf1216ab520efef4883d79be3e0bfa0f6c133d48b4944584f4dd176bb70"
    sha256 cellar: :any,                 x86_64_linux:  "bfe077e352b22846c19500a85d20cf43f39419cfc44474b38416f6538841cf28"
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
