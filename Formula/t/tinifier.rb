class Tinifier < Formula
  desc "CLI tool for compressing images using the TinyPNG"
  homepage "https://github.com/tarampampam/tinifier"
  url "https://github.com/tarampampam/tinifier/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "a83f38a5412ef139226082dbef395c57a635ff25b321012c5bb83cc5ddc39c58"
  license "MIT"
  head "https://github.com/tarampampam/tinifier.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00522c9adc1d43df8560ec334651c793d5e8cd4f0b750c84c5a53645f0d8e811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00522c9adc1d43df8560ec334651c793d5e8cd4f0b750c84c5a53645f0d8e811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00522c9adc1d43df8560ec334651c793d5e8cd4f0b750c84c5a53645f0d8e811"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6661f7e92b7fcb1bf4c379a5f66bbf1d199fdb5d559ed385653cd63d16f37f3e"
    sha256 cellar: :any,                 x86_64_linux:  "725611defa1a30e1042b96f95c03eef5ab2cc80c66207a0508020763edf6a2dd"
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
