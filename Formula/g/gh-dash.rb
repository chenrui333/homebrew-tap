class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.24.1.tar.gz"
  sha256 "928f39ef26711d49d81e827e9759482add511c5fe792c788214db2fdb09bbe34"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281403884d018dd127b5d90bd6b7e163c0c5cb5b8ff1e8bb8fb957819dd18f3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281403884d018dd127b5d90bd6b7e163c0c5cb5b8ff1e8bb8fb957819dd18f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281403884d018dd127b5d90bd6b7e163c0c5cb5b8ff1e8bb8fb957819dd18f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49036461bd59a355d61bc6974a7e8b5e97f002ad4f804659012ad8db7d2ffc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023d039555fef3b3ac916edb5e380754ec3431c31d89a2989cff68f8cd7ef8dd"
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
