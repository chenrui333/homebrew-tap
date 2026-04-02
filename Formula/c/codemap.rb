class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "9d8150ab04289c3897229654fdba47cfbb904ac167a37115be51781f6f05f75e"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebbf05dfd173b7265eaff551d0e978345d29e4b57da722becd26b2e4a2dba6f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbf05dfd173b7265eaff551d0e978345d29e4b57da722becd26b2e4a2dba6f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebbf05dfd173b7265eaff551d0e978345d29e4b57da722becd26b2e4a2dba6f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d0690c2b5b73919cf3cf69e383da22b3e30a93ac48e0fd295c066f37a1a52a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d810009207dbb8716e1149be837a598bef22dc3176289f9d2a6914863e633344"
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
