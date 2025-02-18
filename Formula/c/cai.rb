# framework: clap
class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://github.com/ad-si/cai/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "d01cbe2d0f1755287634c47ca965dcc17a2b5adbf7a4228c53eb37b6dcf8d0fc"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5b517d494253346580da00c7f4d07e4d4ee6458195b60fdfb70f69b857e19c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "591f68053de5f77972d579b33017e32e9e58a9fc6eff88b7f023ad499b4a21ae"
    sha256 cellar: :any_skip_relocation, ventura:       "dd316b641a0231c22fa2f9de69e74cd76bec324564b285136668d6cda8a4734a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d17530b699de505002bea9c2789f1608fa368ffcc29ce853c7f6cadb50316673"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cai anthropic claude-opus Which year did the Titanic sink 2>&1", 1)
    assert_match "An API key must be provided", output

    output = shell_output("#{bin}/cai ollama llama3 Which year did the Titanic sink 2>&1", 1)
    assert_match "error sending request for url", output
  end
end
