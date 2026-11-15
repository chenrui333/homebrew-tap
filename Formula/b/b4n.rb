class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e810c7faa7d5c05e25b796e30b29449b06254071653b6d042828c59d1efc91dc"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7585d4a2a54cb14ef4087b2122b68c108a39e702a2800283a7bccea4d429b04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03fe384291ae35e3568cc8f01198156e98be4f1eb1eb1c1b38a8f40492f661ab"
    sha256 cellar: :any,                 arm64_linux:   "15a2cf2ed52e44f08da61f7b07f5e2bbc0390afb9270224bebac2fd26b5549cc"
    sha256 cellar: :any,                 x86_64_linux:  "f320337ea5eb357bc66a11fd71738c2e848d1ee16d6884989e0ce5b4b201fc67"
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
