class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "b55657694e61cf2cdd3043186a2ff68d506b203566fdb6c177d15c4225bf57ac"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7322aee4f88f992ee45468a5403859f4a9fd04bcc67a5b0d0e9be28d69a25f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7322aee4f88f992ee45468a5403859f4a9fd04bcc67a5b0d0e9be28d69a25f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef95b66e9816666bea08b816faab84096899422c3b92d8133b3cd62089347e3b"
    sha256 cellar: :any,                 x86_64_linux:  "231b3afb059a17e3fc362668e48071dd148bc3275fa6075539ecefcc94d93362"
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
