class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "9a204de87b5ddd4f396e632d23934b77cc3f19399fcf765d7c29604d8379fbd6"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09ead0af7b9ac4b7bc2c4dcc0d538c1a25d84637c2ebb01dce338cbff09c628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e03fb6b917d1424da4baa80bd6649549897ecbdb849e2edfcf0ef5f8bf637935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a20b8c0b2e3a0bcbcbf7200878c3769f4f30fc4aa5a29f29024d02d275c8189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9291e53e01a665a7430eab76cc0417e21adb1fb3b4aec76d21205acc6304c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c752a504788b2de9ad5fdddccd6f37ed2aa385f82e5074dacc59aa23dd266687"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
