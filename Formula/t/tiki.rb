class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0f562d58c2f133145e90afbabcb29f64537d27dff4c6e53d112c758bc85cd1ea"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba60a9bd2b967715d0969e0c8ee358a7fca18d21dbc2a56d38e31d10ced0d5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba60a9bd2b967715d0969e0c8ee358a7fca18d21dbc2a56d38e31d10ced0d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba60a9bd2b967715d0969e0c8ee358a7fca18d21dbc2a56d38e31d10ced0d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea88991517afa94e8ac9dd7c13157e9e9c55dded36c58c459e12475b382bbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3585f0c84692263c819dcd5debda394bc068e534737645270527943ec29e2eb"
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
