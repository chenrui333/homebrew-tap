class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.1.9.tar.gz"
  sha256 "92482f3b3125307be913730d850fd668dde5174108379e5b5c1e48fcb6884a18"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eaefb95890e10d7e12c99c52de843ea718263ad2c6abdfcc1ed4dabef300479"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eaefb95890e10d7e12c99c52de843ea718263ad2c6abdfcc1ed4dabef300479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eaefb95890e10d7e12c99c52de843ea718263ad2c6abdfcc1ed4dabef300479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a373a9d9d38d1d02584c00989795431473084b6eb376735159b6258de166c48d"
    sha256 cellar: :any,                 x86_64_linux:  "76b2ee2d18f4f9e70e103b1c1c331f7f3f5fe0d0e0f44f153440db350b0a1c71"
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
