class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.6.0.tar.gz"
  sha256 "63918c3a27925f87ab1a0dd9ae9bf9a0c5cdbc39c5f4e14daaa6834f271c7161"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac9ad4250639bc434f49479aa0d513bee8d7316352f752f193e25385bc83eec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc14f76e27af0fa44ae46d239d22aa57747a95cf10cea3f18750c5e3af41b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a7fd978d9e46bff7fd2066b3c40e033fe259f4ab0c6e646292fe52cdaa8135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e6b853da1bc23824546cad89e1160f7eb2d0c88bc0ac03640c529ad8553493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbedb4ec7b2a0edb3e106eaa63da65377b191a780c3acadf21df6fe85cd100a"
  end

  depends_on "rust" => :build

  def install
    # Keep binary `--version` aligned with the tagged CLI release.
    inreplace "packages/cli/Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
    system "cargo", "install", "--bin", "actionbook", *std_cargo_args(path: "packages/cli")
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = JSON.parse(shell_output("#{bin}/actionbook --json browser list-sessions"))
    assert_equal true, output.fetch("ok")
    assert_equal 0, output.dig("data", "total_sessions")
  end
end
