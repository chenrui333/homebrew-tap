class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.25.2.tar.gz"
  sha256 "4da2286f02fb513ad06f0fdae70d146933f03718165160318f4f31192efee40d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e69530d90efc53a667358daccd88eb42fad790c1dbc536db228c383c270cae8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e69530d90efc53a667358daccd88eb42fad790c1dbc536db228c383c270cae8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69530d90efc53a667358daccd88eb42fad790c1dbc536db228c383c270cae8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd171bbe3eedf7edb1a46b72782089919bd47b30689a8934feec712f7a290ea"
    sha256 cellar: :any,                 x86_64_linux:  "a22f0f6a68066de5d220c3cb22a366e71e253a86cad97c9d08660c6c394ec741"
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
