class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "2a2f22eb42fb0504a863560976c1c76f1c1ec53fbae8f2b65ea271b96a4f03e1"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bf61938ed5084b7adf229b56533b2dd993fff216f1ef01be7b6956f30fae256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bf61938ed5084b7adf229b56533b2dd993fff216f1ef01be7b6956f30fae256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf61938ed5084b7adf229b56533b2dd993fff216f1ef01be7b6956f30fae256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2653d489d490c6dc7e59cba823945b866cfab215c2adfe552a2af1fb2ac37a"
    sha256 cellar: :any,                 x86_64_linux:  "61fa5f5a2d45b0e9fd7d7b803325bb3587d860e3a0366a7b024c82bac5f308da"
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
