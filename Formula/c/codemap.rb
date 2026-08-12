class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "1946776cac1982739ef57a58004c9790ab2c3fb50988fe3ed3648338e360b94e"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0865c43a8573eb055296e9e9d5554eeb5dfa8e70dcebab7d0c0626279003a933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0865c43a8573eb055296e9e9d5554eeb5dfa8e70dcebab7d0c0626279003a933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0865c43a8573eb055296e9e9d5554eeb5dfa8e70dcebab7d0c0626279003a933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0b14a0f0f08d96f2b353649364f17da9e9cb079860e76294f44352c1782d51"
    sha256 cellar: :any,                 x86_64_linux:  "d70a2e7c554b739c49cf0d1b7b8978288473bbdc81b9d7560efaf215d76bd2c5"
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
