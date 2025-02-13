class AsmLsp < Formula
  desc "Simplistic command runner and build system"
  homepage "https://github.com/bergercookie/asm-lsp"
  url "https://github.com/bergercookie/asm-lsp/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4755848aa7d88856be7e40d0930990b95b46c4593a53db3809d3ba7214d9d16d"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b30871ab4dd4f9d94928c496547ca4dd15b3424f2bd6cddb5b39b4df511a91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489d71f204483110a11266e8dd66396d537431ab877f9d32aa2a194bbd0715d7"
    sha256 cellar: :any_skip_relocation, ventura:       "d5361012dfa26e6ebe43d00efada309ef4dbbb99513632aa76d1e550af90fd71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf71266ea3ba3b2224746c58e2c24fdb0d38c49a4fbe5cffda47fffd6a79b09"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "asm-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asm-lsp version")

    expected = if OS.mac?
      "Global config directories"
    else
      "Global config directory"
    end
    assert_match expected, shell_output("#{bin}/asm-lsp info")

    output = shell_output("#{bin}/asm-lsp gen-config 2>&1", 101)
    assert_match "not a terminal", output
  end
end
