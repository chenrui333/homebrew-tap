class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ec4c8424f484bbaf0646f9cba20b4b08df9bef24b1198b8d056653d03073277f"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436beb5cef0a325cfc61080433d5653c4e5546490bcb559d53ef7365bc535148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a6c3c6112e030a39960311a5ac854fcef05be1dd1b2843e5012667069138a6"
    sha256 cellar: :any,                 arm64_linux:   "32803999c5969b99c1334f2368b866655e7a35234c8f1dc10a4d27dceaf5d2d6"
    sha256 cellar: :any,                 x86_64_linux:  "33524660e23bf6527fb74a9c3fca3d9ee60cc4c0eeefd2f096036a489ecee952"
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
