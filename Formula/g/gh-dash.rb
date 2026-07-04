class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.25.0.tar.gz"
  sha256 "cd36a9f004e3a40d6acdea5183429a50e07ebbefad03eb95915d09ac9d37db15"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9647bf63e818123a02a6382535926a3ad6f29c0e0ccef714a2b52587a0b51248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9647bf63e818123a02a6382535926a3ad6f29c0e0ccef714a2b52587a0b51248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9647bf63e818123a02a6382535926a3ad6f29c0e0ccef714a2b52587a0b51248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644b00f185a098f4ee71ea9ca516e951ee3a5ea018cb767e781d5fa663bba428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "930fc0344cde1fc45388325a3986bb495cd0d8975244ab086ac0930f57f11e3b"
  end

  depends_on "go" => :build
  depends_on "gh"

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
