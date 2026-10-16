class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.26.2.tar.gz"
  sha256 "65b46a8d5eeddf170aff6f30f601df641efd2291a0fcecaff07752f6d33d1ccd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68cc3036016bdabf77e09ede448a1b23d1ba9d40e3d86e5812be8e1781fd463a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68cc3036016bdabf77e09ede448a1b23d1ba9d40e3d86e5812be8e1781fd463a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b10bfa4da2f5f1286e7970302839d85cb624db3d59d35cc6d9fee5df78f1cf"
    sha256 cellar: :any,                 x86_64_linux:  "e651aa9bd3b7e7720c42988862ee50d6c74548598584e197d4ac4f41d4edf8a6"
  end

  depends_on "go" => :build
  depends_on "gh"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/dlvhdr/gh-dash/v4/cmd.Version=#{version}
      -X github.com/dlvhdr/gh-dash/v4/cmd.Commit=Homebrew
      -X github.com/dlvhdr/gh-dash/v4/cmd.Date=unknown
      -X github.com/dlvhdr/gh-dash/v4/cmd.BuiltBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gh-dash")
  end

  test do
    output = shell_output("#{bin}/gh-dash one two 2>&1", 1)
    assert_match "Accepts at most 1 arg(s)", output
    assert_match version.to_s, shell_output("#{bin}/gh-dash --version")
  end
end
