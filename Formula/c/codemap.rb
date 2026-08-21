class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "781b77da5bc436370c5cb9d6847168d75ba1be363304ea6f9b055d69d8503f2f"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "619b5d9bc4587d5fc4c02502f1c1134a93fc1a723d0e4ab809408479f86a1a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619b5d9bc4587d5fc4c02502f1c1134a93fc1a723d0e4ab809408479f86a1a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619b5d9bc4587d5fc4c02502f1c1134a93fc1a723d0e4ab809408479f86a1a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26390e432622d53a5e8fdabe859e00f1e1c9f881dfdf63adb0c5ce090d4c22b7"
    sha256 cellar: :any,                 x86_64_linux:  "d9afa0958ef484774bab8686209f3f7e204712b9ae1fbfe0baa47704d98556f4"
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
