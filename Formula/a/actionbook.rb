class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.4.2.tar.gz"
  sha256 "e520fde3fb33744981c763159933c00d1645dd8e37efa59ec53896187d3682f2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ddb7055f0153e0cde83506ad11ea728422b299ce378bc6bbb41d9ac5813614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd810f49781e0e00cc57832df61868251fa2081d6cbcd1b5a41131e78bcc246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8978309d94bfdb7f2b0782be31f2d0fb42b21e304f635daf810c8c5455273f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae0aa22267c0fdf06176726330ad6858c6565c573ea651d4ed3a44bf315f322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b46836d718a25e0b6840f396478422b2549841c1fbea1dc149b86285f67ef1"
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
