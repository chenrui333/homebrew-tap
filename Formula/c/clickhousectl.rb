class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "ee197e9dcbb9aa3793c69a056f4069d944925b36d264c54cbfffa74c465a32a5"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd31738368c3863c646fb73006c5cc8f38b27c6306d43d72968542aa95dec3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9a61ef1b00a56fdf4d7f41ce90c7e2cad77413f28e49bccb5e8697da4193ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac08dd1c6da7233b8fe073a369fba7ed0bfe83daa0fa266049ffe372e7db773a"
    sha256 cellar: :any,                 arm64_linux:   "4ce3a1e338ec154afa856a52aa1db27c43bcb62cbb4ffbf335bde5ac177b03e0"
    sha256 cellar: :any,                 x86_64_linux:  "db1d6d4c1442cf96ee65e5fa74f39876e1ca8886ec3a25006633224b3954f9b2"
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
