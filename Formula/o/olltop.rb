class Olltop < Formula
  desc "Terminal-based real-time monitoring tool for Ollama"
  homepage "https://github.com/evandhoffman/olltop"
  url "https://github.com/evandhoffman/olltop/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f4a4dabaf6a3cd7898cc0db30b574c4dfd06b63796e0f83f6d7fd794c83acf8e"
  license "MIT"
  head "https://github.com/evandhoffman/olltop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78e0a96750b0e0136c97360c0190cc60aa839b0560975b55a6a9eb0e05599c8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15636314195a29373037a2c82e3bccca60338f5affe09e4963931422898e2517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22b144381bf96dd7cf1e58c1933ff831a1326c36ee6e1ae1d2b3b45c4e0030da"
  end

  depends_on "go" => :build
  # Linux eBPF capture planned but not yet implemented upstream
  depends_on :macos

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
