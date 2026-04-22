class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.6.0.tar.gz"
  sha256 "63918c3a27925f87ab1a0dd9ae9bf9a0c5cdbc39c5f4e14daaa6834f271c7161"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5651ec9c4c2fcf81e1b0272ffea6c10c5a6e1d9401f10d7cb1bdccb6ed4a2c32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344218cdf36806166517a1e7d924b8e76cdd5e0cb976c21591be95cc09fba181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab24cddd4d2a5fddf5e0da9e207541ec7d6e11e21f664ff08bceb4d4d5cdac28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd442b296dc04a4b50619d1b2f75b12abb027b8048925be1b4dc4a5d7cb8f615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3741a417264826899a214af95e057223da631fe9e8952406bb81bc0ff3afa846"
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
