class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "f6129208d1feefeecf704e3fba5ec49fc1623855af3a2d8e26bb7c9b1659b57a"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab7f21564add89bd39b099fda6419c62af6068ff483e8643976f678d5ce05fc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab7f21564add89bd39b099fda6419c62af6068ff483e8643976f678d5ce05fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fca55116ed662334ba41794f485ac18e14c3e584e740e16c9c64efa8fe5a821"
    sha256 cellar: :any,                 x86_64_linux:  "8051e3d663950d3fc20900665fa0ad0d70c0fb88f538bd154d0ea66acd4550e9"
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
