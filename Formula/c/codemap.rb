class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "1121e1a2609fde3501e959cbd314e1732aaeef37901c93c8d9842db1ec7b9a36"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ab38bcc24f64982ef46caafaf83f56df153bb252d5b850b3ba8129d2cb94c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ab38bcc24f64982ef46caafaf83f56df153bb252d5b850b3ba8129d2cb94c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ab38bcc24f64982ef46caafaf83f56df153bb252d5b850b3ba8129d2cb94c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495248ef662ad415e54dde497f80ac907ec19d4313d206060e93a3dee3a528f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7bf68b07deef7d5996a3c643edb68c5348e36434c87cb511a3c0de67b3d454a"
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
