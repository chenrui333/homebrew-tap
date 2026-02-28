class Codemap < Formula
  desc "Generate a brain map of a codebase for LLM context"
  homepage "https://github.com/JordanCoin/codemap"
  url "https://github.com/JordanCoin/codemap/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "e1419a3588fbe9edc104c0c5d60c0eeb7beb78f4542ac2d27457d990b452df00"
  license "MIT"
  head "https://github.com/JordanCoin/codemap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc382712aadbac9d2e6b75a51bec9036de401f9372561404a5f2c360fb8143db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc382712aadbac9d2e6b75a51bec9036de401f9372561404a5f2c360fb8143db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc382712aadbac9d2e6b75a51bec9036de401f9372561404a5f2c360fb8143db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67c14e21d4c164b80c4bf624662c69217b07439af2f89bcd03785e779a2ba84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a0acfa69a6fdd032c5703c5a010dbf113ff34d607b7bdea73ea233f712b9b2"
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
