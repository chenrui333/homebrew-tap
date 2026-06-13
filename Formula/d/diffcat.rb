class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "5433b01bacf2345fa059803dc8c06d1afbbfbf05514a92a4c15dccc5076f4a7a"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eab51628d800d368cf48f88f5b3cb4843c401be9b11ee5944d2ebe811e826b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eab51628d800d368cf48f88f5b3cb4843c401be9b11ee5944d2ebe811e826b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eab51628d800d368cf48f88f5b3cb4843c401be9b11ee5944d2ebe811e826b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db807da7cef26bb0dc36c48a28c636809dcf8034e7eca83b5d4a6abcf74c26a"
    sha256 cellar: :any,                 x86_64_linux:  "183b234fedc3702ad79c96006b084d2b40fc063a1091296ba12cc6ac6c38d936"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    output = shell_output("#{bin}/diffcat not-a-real-command 2>&1", 1)
    assert_match "not a git repository", output
  end
end
