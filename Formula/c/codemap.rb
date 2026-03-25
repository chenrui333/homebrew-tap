class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "3793f70490dae5a612e63013cad8a82c16b390762906d191549606c0c2bf0f80"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f42bf145572f7eb05a7bb556bea169bab104fe067c27f41f0713ed30bf9825b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f42bf145572f7eb05a7bb556bea169bab104fe067c27f41f0713ed30bf9825b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f42bf145572f7eb05a7bb556bea169bab104fe067c27f41f0713ed30bf9825b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dabfa9713bc0d921103cc5a6e5a3dadce30d39d51fba389fd7371ace772088d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c070552c42959515f935d7dcb7a7b81ed3cc4b99afebbd0bb52b014b505751"
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
