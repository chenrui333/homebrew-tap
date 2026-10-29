class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e2efd3d5d132794d3b5b46a3d219c61cfe8c2f40e6c8408917a554fd47464601"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9bbc439e939ebe25a617b1cd8ee47a2d84a445b19e144e18bf1512a1b931f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bab65df630c141ba90d392c125c36b69e8f520a57b5f2ed9f69b936d05cc206"
    sha256 cellar: :any,                 arm64_linux:   "d971af3c9e203141606f0ab30d1397a9e792769e3d9e249e4c5c738ebf57426e"
    sha256 cellar: :any,                 x86_64_linux:  "5c655c678723cb0faf29c2465a0e9fef94a51f6169feb5443717855972a94232"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kubeconfig file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
