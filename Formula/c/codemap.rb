class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "aa8372e899a117def62c98523ea262e88d1eb1e72af37e95615d429e0e79bdf4"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b03433e78002ead15d0e09775d0bd73bbef0a0b8c0d813d93fc6381b92230e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b03433e78002ead15d0e09775d0bd73bbef0a0b8c0d813d93fc6381b92230e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a000283c296b05ca9f696d027b980b24fe072ac0ff30dde733af27b97a97eb4c"
    sha256 cellar: :any,                 x86_64_linux:  "db3e1d2163365fc3209d397966c3ca640af83fa89ea26c7530fcbf3af6a580de"
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
