class Tinifier < Formula
  desc "CLI tool for compressing images using the TinyPNG"
  homepage "https://github.com/tarampampam/tinifier"
  url "https://github.com/tarampampam/tinifier/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "3f2ed775b6b0050390a63d230847e4eb527f35ff058b79ed375236cf5e3e665e"
  license "MIT"
  head "https://github.com/tarampampam/tinifier.git", branch: "master"

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
