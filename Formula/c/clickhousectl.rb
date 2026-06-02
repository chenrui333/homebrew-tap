class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "d342ad448816e65e9bb158b02caa4c5ce7c601c2edaa45195cda833edd50ff50"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12685ac7d31de32da0dec767e49f2c45aae2a333749172a57aa1b2bc6044a4ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227ac708ad781afcf07cf375b55e092aec2e2e0cac3136e69812f79290021616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d4759319608981860b595b30091eb864a11800de938e5c15aa9e3ceab5be40d"
    sha256 cellar: :any,                 arm64_linux:   "cb87c2e65ce6d393d8f185ba05d6616f94176b2fc064bea9cb3f6eb98974f8e6"
    sha256 cellar: :any,                 x86_64_linux:  "628ea782b80e4a1173e05b52e31622a4128c4762697153da5aa71586146be03f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/clickhousectl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
