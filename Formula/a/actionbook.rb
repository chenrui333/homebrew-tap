class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.5.1.tar.gz"
  sha256 "0968dcb1e56ce8dc55ab6b6a16b6ed10af2953c01b041146bcd66ff404e1caa1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a078387268c4c925c0b5f15c35d379119322ff08d880e8f310ff6c0c7dbd578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "559dad235f54612109becf8bead54a612c9de956f64a6e825d7661f6b16eabd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "246e6973b77597f2e06b38ef332dc83cd1037ec989fa89d07d655a97db154b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ee973010e30ec7c89c93b0c4d88aaa2887d77f031f2448daf2307466ab02bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9d7075151188fa923118ccedc35fa92d5bc830d292d788177814491fdf54db"
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
