class Jaggr < Formula
  desc "JSON Aggregation CLI"
  homepage "https://github.com/rs/jaggr"
  url "https://github.com/rs/jaggr/archive/refs/tags/1.0.1.tar.gz"
  sha256 "3277e0b459cc5930e504faa8719c61327fd69c4f840bbc6a08ddd78f6f0e8c0c"
  license "MIT"
  head "https://github.com/rs/jaggr.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jaggr -version 2>&1")
  end
end
