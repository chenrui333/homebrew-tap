class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "aa8372e899a117def62c98523ea262e88d1eb1e72af37e95615d429e0e79bdf4"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7cf8f99d211cdfce1a3c6467f62cd485e925ad3141667f79e7903036b762ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7cf8f99d211cdfce1a3c6467f62cd485e925ad3141667f79e7903036b762ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7cf8f99d211cdfce1a3c6467f62cd485e925ad3141667f79e7903036b762ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2be053ef388d0d9e8096663f8fc42085d61a4776031fa4d312798d583f41c227"
    sha256 cellar: :any,                 x86_64_linux:  "0d7c90bfcd58ca58404444a33d174055ae27eddc044c08e0720c2da27f3f3651"
  end

  depends_on "go" => :build

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
