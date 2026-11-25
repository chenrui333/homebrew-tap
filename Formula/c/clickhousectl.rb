class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "b6d13da6af36fbd4e464843fc0780c14914f1b587ec826c55ccd7b5046e4f60f"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f4629cbc530bffc5cb6f8ca25e2824782d35087832c3b96605abbd549f9bce4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a903a90231a99c68d1588cbeda546aa2c0a9d402f65a9a3fd9f4e03aedef502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cb85647090fa70af7500e9ac071805a415ba457d8b0d9cbb50a0eebc02c8618"
    sha256 cellar: :any,                 arm64_linux:   "e67d485a7aa6717ebc40a78233e90cfb5d14d61f16f459e5accfc8be116bbb09"
    sha256 cellar: :any,                 x86_64_linux:  "82b7c9b74b1d351899953b849bce2a6df379a3e947d432c1eac1f5544425c754"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/clickhousectl")
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
