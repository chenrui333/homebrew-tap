class Amux < Formula
  desc "TUI for easily running parallel coding agents"
  homepage "https://github.com/andyrewlee/amux"
  url "https://github.com/andyrewlee/amux/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "61508baf90d6e1ddb7c2027decc5198fbda6486ef19404bce44ef1791d56e29d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0037916f9b6a3615915f47d54940957381cb66dc46cc31c762f28c4b0b803d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e0037916f9b6a3615915f47d54940957381cb66dc46cc31c762f28c4b0b803d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c31cf915f67a6c4f55aa99dc64d63f031a567c0b4d80fa7f1b49fe0a9852ff5"
    sha256 cellar: :any,                 x86_64_linux:  "5ea7f7cdfedd34ce1f0580485c6819fd72e4b126fa39d116fcefed142a954e74"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
