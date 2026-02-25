class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "65673bdc6c57faeea229c63d0399a4ce60385b0e2614f94c39aa6557acde3c6e"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8657051a43962e01df78b42ddecb98fca267d0e0e79033d74f170c498dc48a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8657051a43962e01df78b42ddecb98fca267d0e0e79033d74f170c498dc48a78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8657051a43962e01df78b42ddecb98fca267d0e0e79033d74f170c498dc48a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97989ee0554b4c196c252bd48952ff1e82cc3f82aabe277e6c4add14d65711e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53ca53801ba796d05c8e69bf74a514c1b93884d96e99ae7c8f0c60b55ef284d7"
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
