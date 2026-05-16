class Olltop < Formula
  desc "Terminal-based real-time monitoring tool for Ollama"
  homepage "https://github.com/evandhoffman/olltop"
  url "https://github.com/evandhoffman/olltop/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f4a4dabaf6a3cd7898cc0db30b574c4dfd06b63796e0f83f6d7fd794c83acf8e"
  license "MIT"
  head "https://github.com/evandhoffman/olltop.git", branch: "main"

  depends_on "go" => :build

  on_linux do
    depends_on "libpcap"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags:), "./cmd/olltop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/olltop --version")
  end
end
