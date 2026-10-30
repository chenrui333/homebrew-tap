class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e2efd3d5d132794d3b5b46a3d219c61cfe8c2f40e6c8408917a554fd47464601"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4da0418ca92dacc40562f6a8156e7ca53a01ddf5693f85216fc4003bd7c7f99c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbc276f0a421ddf313b3867a66ce190fbcad8f9fd9111e7c029607c8362f635"
    sha256 cellar: :any,                 arm64_linux:   "4f689efe590627bb274f72bd01f5f2aea179b0c42c7d659bcbeb8c006e5399a4"
    sha256 cellar: :any,                 x86_64_linux:  "c6ae6478c5b0b64e9ef194db1cf5d92af2e58dc539114af27c34c6c6c661a711"
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
