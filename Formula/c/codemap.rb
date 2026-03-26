class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "d4354c9c8009bde1214ee7230d8f50c23617b14b37cc1307e5a7a53733a369ef"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef478d2068986ba25fd5afad6514c871d7992978bd2def3c9048e8541a897ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef478d2068986ba25fd5afad6514c871d7992978bd2def3c9048e8541a897ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef478d2068986ba25fd5afad6514c871d7992978bd2def3c9048e8541a897ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035ed196b3d8e3bb59db97cd832e5efec29fddd76796bfcc8c75fbf499a5465f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6ef3831ea46130c0e01d7eed6c54dbafcb6ba1d9cd04ec62bf12661557d979c"
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
