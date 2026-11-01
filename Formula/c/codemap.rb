class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.6.3.tar.gz"
  sha256 "d70bf80a3eba111a2ac357eef70252a958c608b03d5c5fbb91a6ef8a8c91b21f"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0a1c8398f7437790a2137ad2bdd0b639f9292115b515dfd4898dacf5b470b4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a1c8398f7437790a2137ad2bdd0b639f9292115b515dfd4898dacf5b470b4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c8ca5b89e5d066c792af80a8d6fddb664beea9ec5517f5ace02806466d37a96"
    sha256 cellar: :any,                 x86_64_linux:  "17fb0c5727cddc28e96e681586279897abefbc27d7f297085ae13a410f1383e2"
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
