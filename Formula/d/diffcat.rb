class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "df9daaee935c31cb89b64437121d8acb80d0f2d08f2dbb6e732cabf7106bde72"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19493d06418e0d65a881d1eb7d9c96a1e39d2246a1b0b152afab9af2e39a3ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19493d06418e0d65a881d1eb7d9c96a1e39d2246a1b0b152afab9af2e39a3ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19493d06418e0d65a881d1eb7d9c96a1e39d2246a1b0b152afab9af2e39a3ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f68416759dfc47c6bad67a6e7482d40f912ac46c1c970d50ef6ca131bfd913"
    sha256 cellar: :any,                 x86_64_linux:  "f9ea8552577d2185efce8839dddc149b25bb6462eb8422334bf00e74e93565b4"
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
