class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "1ebb0244f8f255cfd422e67852201fae1668cd41e776a4ead3db1ae2afefcf1d"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "986964327db6f495d2fb792b2e2087afc496f3e162e8aa41d312f9f8dacbfc6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a551f27d8b14decc468aa91dd4cf682d808ca1e5da6e601a5f67b2a9bbcd08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1822a096de6fd37e76c5d0b9c5dc23099966859c57fdfa720b3b23d4592ae97"
    sha256 cellar: :any,                 arm64_linux:   "5927a1272a49a20c9989f118dbc17bb2cd4fa0db706285fad490c8d40e8f9f2a"
    sha256 cellar: :any,                 x86_64_linux:  "3ef3832933c129e7d5fce190e56d6375fe98a12267f06e59883ca7d94049a228"
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
