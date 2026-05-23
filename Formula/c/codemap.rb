class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.7.tar.gz"
  sha256 "2d47effcb25236b9905d3bdb09a01fbfa916b45229b5cb8c492929df2488c29c"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "949c446130ea6a39bbdd8fba15d740edf7a0e7d9f435fe9066fb95d721bd4d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949c446130ea6a39bbdd8fba15d740edf7a0e7d9f435fe9066fb95d721bd4d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "949c446130ea6a39bbdd8fba15d740edf7a0e7d9f435fe9066fb95d721bd4d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf0625ccee48ab1060bb610dcd29f8b0244d715555ce9d1eacf8338e5cd028b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d327c6c1c3897cf8e2cc25d3abb3dc75c6f94996cdd9b430745a3fd6946b6619"
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
