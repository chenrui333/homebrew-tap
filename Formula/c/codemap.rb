class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "3793f70490dae5a612e63013cad8a82c16b390762906d191549606c0c2bf0f80"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6955927bb21f54f3bbb05782eeac252fcc9e15fd73dd3a5f8a3043e1c3b5f0a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6955927bb21f54f3bbb05782eeac252fcc9e15fd73dd3a5f8a3043e1c3b5f0a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6955927bb21f54f3bbb05782eeac252fcc9e15fd73dd3a5f8a3043e1c3b5f0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a35406bcbb8f573e16a7e016b2438326e7869bc86e8f7f93acc005551879c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f075f546737d91e34d9114bbe7166389be49d86f315a9f792b0c051d9c0ffa"
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
