class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "18c38201505667cd41033f7cc8084f2c447230310ca4e0de683c9350ebceb56e"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3626d4dde2aeda447530c70d564914b6f5e2d90a41ebc7804b8d82177ff106b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3626d4dde2aeda447530c70d564914b6f5e2d90a41ebc7804b8d82177ff106b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a008208f919d2bdede5bc76b2b39e2081ffc878ce93029a5f806c1bab231a9f"
    sha256 cellar: :any,                 x86_64_linux:  "437283b422a75935d05fa80f9806e78d7f423f14c680b19b1539a5ff52f629de"
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
