class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.26.3.tar.gz"
  sha256 "bed2fb9d856ba15c721d32a8c62f49aefe0ab869703e5941e447e287705c3a60"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc3a6a12ebf43fa72f3e15556902e6f71efbdbe6ad9d6f5db384cd1427b5fc5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc3a6a12ebf43fa72f3e15556902e6f71efbdbe6ad9d6f5db384cd1427b5fc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae70884383be1bfb18fdf133455c5ed8b4c80cd723327bbeef98fde13697105"
    sha256 cellar: :any,                 x86_64_linux:  "00f412b3384cf26aa97e8fee98b69aa3295f58713f82d0b6768cf9a044f707b8"
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
