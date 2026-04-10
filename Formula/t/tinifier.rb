class Tinifier < Formula
  desc "CLI tool for compressing images using the TinyPNG"
  homepage "https://github.com/tarampampam/tinifier"
  url "https://github.com/tarampampam/tinifier/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "40d8863a26c8c0e8d41b05955527e938a6dbdcf39d15255aed604375c403245b"
  license "MIT"
  head "https://github.com/tarampampam/tinifier.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "784fc2933fce363e6d444312e3607aeeea5ca225ecc249caea378ac2b00249d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784fc2933fce363e6d444312e3607aeeea5ca225ecc249caea378ac2b00249d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "784fc2933fce363e6d444312e3607aeeea5ca225ecc249caea378ac2b00249d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "508df1e9f9ec18a259675226a13e17807503a232a9ee5e2b953c978814462565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1300d44a72272ffb72ee562ecfa11c9894330f452dbf677252ae51e2a9576786"
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
