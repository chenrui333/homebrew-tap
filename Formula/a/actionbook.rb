class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.4.1.tar.gz"
  sha256 "098ab9b7e27b7787e3b1a8818641a40b97d8d1f7ef5fae64e8f2020de56ce10b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b112feb1c5446c3ee03f5dd93031149751a1a405f4949f7eefa9b4160108ade7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a22cf06e0ec2e42a4ba0290c73d570199d87ff8cc2069eb51b975056bab63f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29af4257747b95f1fcb4a23e64adad9960f8ab63710144aeb7a1a11b04e11269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaaad961c2c0a5bfd55e56f159b07db6b1765669f13ef8ecca96456c2577cd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ecc2dfdb4fcd24c9a915d0c7009ee2c6ccc0156f0f10ce43ceab2b28319a754"
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
