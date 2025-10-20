class AsmLsp < Formula
  desc "Simplistic command runner and build system"
  homepage "https://github.com/bergercookie/asm-lsp"
  url "https://github.com/bergercookie/asm-lsp/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "9500dd7234966ae9fa57d8759edf1d165acd06c4924d7dbeddb7d52eb0ce59d6"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13a85bf32fa26ad27f0ae108620b73f93ef441a2ea03ad38d174b8e5f775a214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4571a9c8bcf80f87ef3c0691ccded1a98b6b9f24a7868baab2f63b39f4863eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a7b43684e2113326ca6b8e6e9156a67451e9599d8b8243a7b2432b845efea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222fd553b4b01bb8c417ccc87ed90b9da432e429b4f09ddbac656ba626aac298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05eb0d9b223fef0d7a661489edcfa8422b0252b13141073a6a2e4e79f3063270"
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
