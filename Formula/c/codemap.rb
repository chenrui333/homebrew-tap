class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "07f2af8fb2e9959776b1223daee9274f7397ae70059b532271d724a0e1c7be92"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce814884dbc79ea7b3675c35b299ec7e8bd93bd158a907ca32bdd42f06b223e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce814884dbc79ea7b3675c35b299ec7e8bd93bd158a907ca32bdd42f06b223e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce814884dbc79ea7b3675c35b299ec7e8bd93bd158a907ca32bdd42f06b223e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825efff2826958d03d46f877b6ebb8af61e3c0ce674417d683d381ebbe5e6a93"
    sha256 cellar: :any,                 x86_64_linux:  "85786afb9d0fdd28dfd34a4647b2512ae8d9e08b7bf3ee57f51c7a1c6f7535e8"
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
