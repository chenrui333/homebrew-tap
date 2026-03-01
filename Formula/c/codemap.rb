class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "d1080415b226d29d566ff1f941e10dee1ee6db665b5865ce2f6d73b02d6f1459"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46e7f38b07f480f6daf01b07fbe4ddeb5f9f913c1b7bc6acfcb99ad40612d2ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e7f38b07f480f6daf01b07fbe4ddeb5f9f913c1b7bc6acfcb99ad40612d2ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46e7f38b07f480f6daf01b07fbe4ddeb5f9f913c1b7bc6acfcb99ad40612d2ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1988ff48e7cb0041e7fa379572442bbc6bd7eed8ff58384ae2bc7d29906aeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d26c5cccbd106482dc76fe0dae69b32de8f5f2c5b861fed864ddcc9ac7cfa2"
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
