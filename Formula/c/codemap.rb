class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "1121e1a2609fde3501e959cbd314e1732aaeef37901c93c8d9842db1ec7b9a36"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c33f03a0d695bc027def8bee3037385b67043ab6d4aa880e4f69e82de121b006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c33f03a0d695bc027def8bee3037385b67043ab6d4aa880e4f69e82de121b006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c33f03a0d695bc027def8bee3037385b67043ab6d4aa880e4f69e82de121b006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f424d47dc5728ae80c7746063ef1173779d87373aef94e9670b763407649e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e2daf3583dea5bf9b3b953866537d309f0337fc1fab99437d5f27c0a99a98e"
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
