class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.25.2.tar.gz"
  sha256 "4da2286f02fb513ad06f0fdae70d146933f03718165160318f4f31192efee40d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "253b060d1d193288cc494b5729c9a52f4fc2321ca9c61b94dda286b38c6b5ed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253b060d1d193288cc494b5729c9a52f4fc2321ca9c61b94dda286b38c6b5ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253b060d1d193288cc494b5729c9a52f4fc2321ca9c61b94dda286b38c6b5ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8a7d3d81a88301d611479a63309b4c271d1b57fc2dd7e3c1a652c84f72b488"
    sha256 cellar: :any,                 x86_64_linux:  "9e2160410fb7bc72c7da0a6049fcda43e97649c4d2d85c8cf4c548aea6f4aebe"
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
