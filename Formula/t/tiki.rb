class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "840a2f467ebc6c31be981194caecf59b1c1b9e73448b5aa0e1d2a2867a9901f6"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d996d15566779352c43b6bc51b44b8dbc31b9ea1623669b2f0626bdd934aa72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d996d15566779352c43b6bc51b44b8dbc31b9ea1623669b2f0626bdd934aa72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d996d15566779352c43b6bc51b44b8dbc31b9ea1623669b2f0626bdd934aa72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d88e0ffa5b06e89b6eec50c15bb5f4789e24f1022f96a95988d32b2e1929f015"
    sha256 cellar: :any,                 x86_64_linux:  "4aa6157aaf13a125d345d91bb3d2b40a6fd81dd239a231f485c27752d8c1f411"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/boolean-maybe/tiki/config.Version=#{version}
      -X github.com/boolean-maybe/tiki/config.GitCommit=Homebrew
      -X github.com/boolean-maybe/tiki/config.BuildDate=unknown
    ]

    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    output = shell_output("#{bin/"tiki"} sysinfo")
    assert_match "System Information", output
    assert_match "OS:", output
    assert_match "Project Root:", output

    assert_match version.to_s, shell_output("#{bin/"tiki"} --version")
  end
end
