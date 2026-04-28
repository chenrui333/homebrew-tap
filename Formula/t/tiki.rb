class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "3c6a694b063c9f406cca0e5577f82f260d9d3509a62018ec5caadb53405d53c1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d988a4d8df130231d4a6445633bf55e8e902d04d9e64b8d76af310fadc44a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d988a4d8df130231d4a6445633bf55e8e902d04d9e64b8d76af310fadc44a49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d988a4d8df130231d4a6445633bf55e8e902d04d9e64b8d76af310fadc44a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ac18a3e5cc768fcbe84583d418cc901517d25904f9afb91e8783ff99115fe08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5f4a04fa73c964f4ebaddc855eb2f70d69d78e72ba76ac3afdc9a0dfc81ca8"
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
