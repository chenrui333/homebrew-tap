class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "e216ea8671bda07e75a30777b6059f0fd740d60f6261e009f4b6f1b062a807bf"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad24a1ed6852d8b7a6462e2e8cffe8dfa16cca46d4e280508854248140002f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad24a1ed6852d8b7a6462e2e8cffe8dfa16cca46d4e280508854248140002f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "136c44b12fa750c0c35fb1a9b79294513f33377a86ea0f126f7e9a2cdb4170b5"
    sha256 cellar: :any,                 x86_64_linux:  "6a33b407bb7a74b8968a73b3ba906014add2fa4431d33416d5b69cd27a034e79"
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
