class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "f6129208d1feefeecf704e3fba5ec49fc1623855af3a2d8e26bb7c9b1659b57a"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a6dda5c5850e53648d4efdfe980920e68689d271b9ecdbbcc6cc866e6c4ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a6dda5c5850e53648d4efdfe980920e68689d271b9ecdbbcc6cc866e6c4ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abaf4ff3d272ded61c89a542ee0f10fb8af02f83177b4a7a6fe0f854652671c6"
    sha256 cellar: :any,                 x86_64_linux:  "ec4f9805a54d34b8a8984cbf0b5f30ff6ee9adda30b73599727a5d1537964f39"
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
