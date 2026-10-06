class Olltop < Formula
  desc "Terminal-based real-time monitoring tool for Ollama"
  homepage "https://github.com/evandhoffman/olltop"
  url "https://github.com/evandhoffman/olltop/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f4a4dabaf6a3cd7898cc0db30b574c4dfd06b63796e0f83f6d7fd794c83acf8e"
  license "MIT"
  head "https://github.com/evandhoffman/olltop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b53a6c8ea92aeecadb5b8be45ec457f34ba702f10a9b6be94d134307ef838678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22794b1d1e4ad70c9bb43159e90f2cb89aeb753b3477d486adae4aa21f71bf39"
  end

  depends_on "go" => :build
  # Linux eBPF capture planned but not yet implemented upstream
  depends_on :macos

  on_linux do
    depends_on "libpcap"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags:), "./cmd/olltop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/olltop --version")

    # `--debug` opens ./olltop.log before polling Ollama; a directory there forces a local error
    (testpath/"olltop.log").mkpath
    output = shell_output("#{bin}/olltop --debug 2>&1", 1)
    assert_match "failed to open log file", output
  end
end
