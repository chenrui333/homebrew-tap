class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "552e5a31431abf37a7476ad343bbfc194d81b5b421dec1546345cdcc09fb5faa"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "039aeeb7f8125fbe1d6d2a3c646b72c29c967cfe057cbbb4e00a5631ebb2742d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e693a2fa94e618bf8c115e591924c770a2c36234e5d2af196d1eb0ccc616f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7311116aba8769c1f30bfd2f8c95f2bd8d4ff6e56bb7e092809c745896232606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfe1b4c8f33de429847c81eceddd5c86432f40b6d4f926d246978517999562c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
