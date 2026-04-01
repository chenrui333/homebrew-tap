class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "62b1fa93db51c19177f8877b3878d9079c3a2647ae7c8aea657ec84c22eeac1a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e1655b3c46ce6e5b7cc9473901b3988fab324853caf3e07a3c4605e500003a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e1655b3c46ce6e5b7cc9473901b3988fab324853caf3e07a3c4605e500003a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e1655b3c46ce6e5b7cc9473901b3988fab324853caf3e07a3c4605e500003a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c8ec1241f8c4ac834723e5e86bcfd8131c2e0a0c033f6aa11b1d33d99129b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a205c213f21714e2f7f4354145ed8da3a29dd5090a282416e5862ea4d98b9a55"
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
