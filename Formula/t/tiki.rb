class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c9a80bf800859a77cc6ba004e896917880b23b8fd280ac889de2482e6a26997b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "918667e9ee28218e0b50153280dfe70d8448ac893e246824b416a7496217c9aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918667e9ee28218e0b50153280dfe70d8448ac893e246824b416a7496217c9aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ce3c9446d1cfc226a9773fa6481078a9f14781d5b9c8d3744da73876815cac"
    sha256 cellar: :any,                 x86_64_linux:  "8e390dc69d6476ef3e0c6f2ff8a449595147bef978f33bbaedca7f4350fb11e2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
