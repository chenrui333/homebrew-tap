class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "b3b339fd78996f998cc84c2316f38dc79e5d0e94ac8c584933ee66a8870e7838"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9960190e6f4b255078a61b903a8d178c56b34f915ef9ad16abf64f9a7b855c13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9960190e6f4b255078a61b903a8d178c56b34f915ef9ad16abf64f9a7b855c13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9960190e6f4b255078a61b903a8d178c56b34f915ef9ad16abf64f9a7b855c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2a238d088a3364fc69f383d99fd30b62992f4e5fb1cc765cb6250be0fecaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd0d7308a958984d35dced1c22d00dc92f263bce8d67f3f75153a2a1ee13348"
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
