class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.23.2.tar.gz"
  sha256 "aef43a5998fa16447a832797484984ed8894b65c94acebc17f8210c2b3b4b687"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec62ea99eb5f3f4d3b43a42ac49fc2f01a6eaf4de36d431c259d437c10c71946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec62ea99eb5f3f4d3b43a42ac49fc2f01a6eaf4de36d431c259d437c10c71946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec62ea99eb5f3f4d3b43a42ac49fc2f01a6eaf4de36d431c259d437c10c71946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f7e698a1c87c59d0441d167dd1cb624ea75294abb9f9de5a837043e5216861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb037d544df9e92aac639027c307449e223430c7aaada0112b20624eaacd7be"
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
