class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.26.1.tar.gz"
  sha256 "3e60e3dbd82ff0ea8a040dbde1d0768f1bea5f9bc79e4a6926bc57d8027e399b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7626698c9ca275db150a7cb1d4b18c8e3994a6b58b733437c52eab474bacd84a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7626698c9ca275db150a7cb1d4b18c8e3994a6b58b733437c52eab474bacd84a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afe868fdfdb821e0ef94c39aeb8ddd36efd746c216d7f4d90627c23fb08ae48"
    sha256 cellar: :any,                 x86_64_linux:  "d0d10bf46e87ca2f8e065a3e753f4072fef5cafb1d58722ea83852ba958be3ef"
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
