class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "7bf1e53898e21ff9aeff325e541039a4c20ec4cba01c49274d44e7c5e3756e20"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dbce504461605d81963c1c28c8290fd08fd774fece9539f15ace1ff2c443348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dbce504461605d81963c1c28c8290fd08fd774fece9539f15ace1ff2c443348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a99499a002a74ccd54fbc4254058ea8a18d9e37434234a8f1a22134d57c5093"
    sha256 cellar: :any,                 x86_64_linux:  "15fd9608b548b033769c74f7dd555f7c31d750b844b2950f43dd31c6fc473b2b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
