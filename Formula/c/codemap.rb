class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.8.tar.gz"
  sha256 "5b92e5290efa056d83255aaa4f6254599b2a2de52fe7002b7dc9f9325e4e9b91"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b98b316844660a3fe4182b04c56a73cba8c4b414a47084259ed1c35d572e342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b98b316844660a3fe4182b04c56a73cba8c4b414a47084259ed1c35d572e342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b98b316844660a3fe4182b04c56a73cba8c4b414a47084259ed1c35d572e342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8df8ed9136226d346f2f92a40ad293caf301e3368a6424e152f9c2ad5002008"
    sha256 cellar: :any,                 x86_64_linux:  "2876b12dc68b576fed5c139e26fce9b5fa7e5885c6a3742a59682559fd9dcc2c"
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
