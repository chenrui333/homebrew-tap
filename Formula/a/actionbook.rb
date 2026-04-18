class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.5.0.tar.gz"
  sha256 "bc12485f6a2c37b3a0c0e4b2273e8a4cbca8163c65c44f91834493d4591d0f8f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42826935ed71432570c4d51ed977ec6583f30bece9c5fedd956711617c10622e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "761cc6e002d69947bcbb630a0d9f14ec954c80284da1cfbe5fa46689eda14a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97f12f5c2f340931ad2fc12c8309c7a4bde5d7f50d9e7c2cb89e16853251916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ad5aefc581cd46fdf0d2c94cba509af389d3f3380fb767829628b63cf373102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0eba35acb896d88fa92cd08cbd0b910e91fb66e1c357431154f4ac21eb4498"
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
