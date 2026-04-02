class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "9d8150ab04289c3897229654fdba47cfbb904ac167a37115be51781f6f05f75e"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a52d37e1b5810b20c1763e4ad94c76dd81444d8f596e08d50734df80df50723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a52d37e1b5810b20c1763e4ad94c76dd81444d8f596e08d50734df80df50723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a52d37e1b5810b20c1763e4ad94c76dd81444d8f596e08d50734df80df50723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59aa6dda339b89815ecfc6b0fedad254a83d2c33d04e03b12f8b9edb267e3133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c07ed91e01d61735fa7d150dbf66988d06eb92882668d9d2c585dc898a27cc"
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
