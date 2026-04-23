class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "b3e9e6887678d35acb6e986e8b2fa0be1a51f5f5dbe41071436e977d6728a112"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "726493b8add237b9823916bec9753c4b242c614cec07266791a693ada8f9f073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726493b8add237b9823916bec9753c4b242c614cec07266791a693ada8f9f073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726493b8add237b9823916bec9753c4b242c614cec07266791a693ada8f9f073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a334a1c072ec104608774a0785ba4993795b92778d8a72a56364bc464738d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36525dd803e537866eda6f0835afe97a3e1feec5821a95ee2d33a4e7a6bd0ee4"
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
