class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "18c38201505667cd41033f7cc8084f2c447230310ca4e0de683c9350ebceb56e"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "823f27fc7db89dadd011f4ed33b42c7d6b4d1022159e9c0874e8551b2f492ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "823f27fc7db89dadd011f4ed33b42c7d6b4d1022159e9c0874e8551b2f492ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4729edd67559854f2ddc5aee37e2ea6b1f47422f856f8ae2c3374a7706a97c8f"
    sha256 cellar: :any,                 x86_64_linux:  "c945b168878c711c3a56eada103c3577059e3575ebef947880ac6f41ffaf51b5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    output = shell_output("#{bin}/diffcat not-a-real-command 2>&1", 1)
    assert_match "not a git repository", output
  end
end
