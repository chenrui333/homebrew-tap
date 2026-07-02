class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.10.tar.gz"
  sha256 "ca8b7c0e9f136bae3f8d8069df7a948a779a1ed69c605d2737981ac78473d998"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4107da099ff72ccc8e46567350bc530e3bbcdc0802074d27d6ecb7cea726410d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4107da099ff72ccc8e46567350bc530e3bbcdc0802074d27d6ecb7cea726410d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4107da099ff72ccc8e46567350bc530e3bbcdc0802074d27d6ecb7cea726410d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d0f594e08b1d1cc60978d663a7bd981b8a1cda6ff24d31065c580fe2a4d3ac"
    sha256 cellar: :any,                 x86_64_linux:  "0b2e37a70c91d80d28820e06703d748a61d4d8a3ca2c07d014277c4b3154e3e9"
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
