class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "65673bdc6c57faeea229c63d0399a4ce60385b0e2614f94c39aa6557acde3c6e"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89666d5086d4fef0815c2bd8a4e64929a625a46282cdb0651d4a8f20c5fdb3fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89666d5086d4fef0815c2bd8a4e64929a625a46282cdb0651d4a8f20c5fdb3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89666d5086d4fef0815c2bd8a4e64929a625a46282cdb0651d4a8f20c5fdb3fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034c4b73b47af816be1425327cc7a4e918e6c9885f97e527640e24834c106bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46785771d115aab64e700d9f0c6772bc535f80b2692ff0f03a06dd6de41a4616"
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
