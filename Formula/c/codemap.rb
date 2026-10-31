class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "7b902f4677b1bedf25e8e19b17cd80b51353da6811664441d929ed794d018a72"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d66bb4d318cf8d96cce2c275a726a71bea91fc2f0b66c81cb133d63ebb79f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d66bb4d318cf8d96cce2c275a726a71bea91fc2f0b66c81cb133d63ebb79f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "647339b0d868bedf0f5ddcd6ad81aa41569a01bb26b9cfec74b9ddb4a6959d47"
    sha256 cellar: :any,                 x86_64_linux:  "a828f48199d02a7e7d34a7d02a4e7f51227153840e25e2c2411717d99940cd34"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main
      func main() {}
    EOS

    output = shell_output("#{bin}/codemap --json #{testpath}")
    assert_match "\"path\":\"hello.go\"", output
  end
end
