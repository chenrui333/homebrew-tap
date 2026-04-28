class Tinifier < Formula
  desc "CLI tool for compressing images using the TinyPNG"
  homepage "https://github.com/tarampampam/tinifier"
  url "https://github.com/tarampampam/tinifier/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "3f2ed775b6b0050390a63d230847e4eb527f35ff058b79ed375236cf5e3e665e"
  license "MIT"
  head "https://github.com/tarampampam/tinifier.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e500802eb5442399fd0edaa608553a7a846ba1e19ba9015bebe71c87b152f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e500802eb5442399fd0edaa608553a7a846ba1e19ba9015bebe71c87b152f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e500802eb5442399fd0edaa608553a7a846ba1e19ba9015bebe71c87b152f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff814dd19b6ef650674e9c315998f569667c330880f0888602693a7d34b3a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcfe27b748a55e6d52a433cb9a0d294f1e17de5e271b1c69f80201d0e81ac9a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X gh.tarampamp.am/tinifier/v5/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tinifier"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tinifier --version")

    output = shell_output("#{bin}/tinifier #{testpath} 2>&1", 1)
    assert_match "invalid options: API keys list cannot be empty", output
  end
end
