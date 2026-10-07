class Tinifier < Formula
  desc "CLI tool for compressing images using the TinyPNG"
  homepage "https://github.com/tarampampam/tinifier"
  url "https://github.com/tarampampam/tinifier/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "a83f38a5412ef139226082dbef395c57a635ff25b321012c5bb83cc5ddc39c58"
  license "MIT"
  head "https://github.com/tarampampam/tinifier.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4960365c171d5c622413575569dea0dcf559dff0caf126ad6ee105205a8f6d7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4960365c171d5c622413575569dea0dcf559dff0caf126ad6ee105205a8f6d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3d55014f2cf079ec4c6a91278d8573564b3e4673e6d017ea45dab44239c615"
    sha256 cellar: :any,                 x86_64_linux:  "75248b63e18889c49b5d371740520c194754a7b1d5540a5c6cceb9b7f2eacdf8"
  end

  depends_on "go" => :build

  deny_network_access!

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
