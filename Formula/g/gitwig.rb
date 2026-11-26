class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "929c0ecb93b9d2a912d15a5898eb2069bda79baea9df652cc79c10af5f53fec8"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c6792b2185ab68e044ae221a2870759994b23fc72c564cb990d4622d82c251ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df760df336e595ec3c8ffe9bcd02c9c45ed6b16c1f86b2c23b31440d5554e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e66f8b0393b6744eb3b7d693836c884f9f6fa7c93db4389be2cec5f1aa00d9"
    sha256 cellar: :any,                 arm64_linux:   "4b935dcd825a926826797d7e2c57072e5c41c3af23aa7c28eb0657ad11aa94bf"
    sha256 cellar: :any,                 x86_64_linux:  "4872e0cfff18ac025a5ba3c0c59ba42a169e4f01e47796caf5f69aa7f9953ae0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitwig --version")
    assert_match version.to_s, shell_output("#{bin}/gtg --version")
    with_env(PATH: testpath.to_s) do
      output = shell_output("#{bin}/gitwig 2>&1", 1)
      assert_match "'git' command-line tool not found on PATH", output
    end
  end
end
