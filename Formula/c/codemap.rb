class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.6.4.tar.gz"
  sha256 "3f0f81359ea7c6417a665f09d5bb65c4098508b796d2f8ab61d7d0be5c12e284"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4085836402bf2949e847c894d62f88e2e550df3677e25ccb2397651a3fc4a1f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4085836402bf2949e847c894d62f88e2e550df3677e25ccb2397651a3fc4a1f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da88a6aa3d669f80a3fe069cef5e2721c96335bb8eee354fa764780b058b9d82"
    sha256 cellar: :any,                 x86_64_linux:  "ae24c24c2bef4eca7295390ad526a554eee4517d5791b6580440dd348aba4a63"
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
