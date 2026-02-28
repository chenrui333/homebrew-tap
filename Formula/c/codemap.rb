class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "e1419a3588fbe9edc104c0c5d60c0eeb7beb78f4542ac2d27457d990b452df00"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e157cefb2e781b2211e7c628b1f8e564a098915c7b6cf650503180eb6d71650"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e157cefb2e781b2211e7c628b1f8e564a098915c7b6cf650503180eb6d71650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e157cefb2e781b2211e7c628b1f8e564a098915c7b6cf650503180eb6d71650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30f06c56686ffda94f14051b6ad013cdf69e1f7c6ba76b239aca7a82f954c3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5a862f0fbb54f8331442453698e44cb0956ed120d0adbce456569286f84fc0"
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
