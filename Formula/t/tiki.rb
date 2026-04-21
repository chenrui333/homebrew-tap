class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "5789765010189eca582881ff24f417512485ae49dd788908b4afa358b5eb6e00"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18910b139b39d25451f7a5fa23db3e4baf2270fa3c4b6e4ee1921057b0120bd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18910b139b39d25451f7a5fa23db3e4baf2270fa3c4b6e4ee1921057b0120bd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18910b139b39d25451f7a5fa23db3e4baf2270fa3c4b6e4ee1921057b0120bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d34631646de65eb243be3f97b195e4b9c64588dd18c3e3f286f4d7f8465a2add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea0dbd4f40c863d5b5895b9d0003fe23b852bd1f527db4e460da1aab7effd4c"
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
