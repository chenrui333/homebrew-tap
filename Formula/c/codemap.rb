class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "7f50d666a769ea5e1c57251ff0c3782fca22e295d54195fff7aa9c7234bdee47"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07a00fadd4b3bf7e66c8b65a77dcf8166117f3c23835838a7b08c7320d466a84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a00fadd4b3bf7e66c8b65a77dcf8166117f3c23835838a7b08c7320d466a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a00fadd4b3bf7e66c8b65a77dcf8166117f3c23835838a7b08c7320d466a84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd8638a9f76a1bdc001c3e742c08d0fd7614ca50a3f97c4bc1b7ba832049668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f533b494034a4a3c242b21ac5782e624704a37fc0f6db5fafd0c95b56e35ca"
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
