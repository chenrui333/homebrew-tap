class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "3c6a694b063c9f406cca0e5577f82f260d9d3509a62018ec5caadb53405d53c1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f306d8bbf69c5af479f939831a98454773c4f31c3c8e89c59a5c06b020d411d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f306d8bbf69c5af479f939831a98454773c4f31c3c8e89c59a5c06b020d411d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f306d8bbf69c5af479f939831a98454773c4f31c3c8e89c59a5c06b020d411d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb0b93e33dcc4999dc8e1c9537f922f52e3b20987c1fec5801099938fa50062b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d63a9a5e9459fd232774fbaf8bd38c91350fff40e8d9f91c0c88ec0724b2368c"
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
