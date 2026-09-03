class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "1ebb0244f8f255cfd422e67852201fae1668cd41e776a4ead3db1ae2afefcf1d"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a2a3639973d1b4731c53762736f8d614cd01d2e251bf8837683770c655d4ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98be6c4ccde36cc213863f3cbeeb0b121cf36a206491eff92a68d4d98723606a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "384ec8ab403199902e9d2812a935d7dda2f320bb41343bd83f0cce70027effe0"
    sha256 cellar: :any,                 arm64_linux:   "91e05ee9d4be78dca868bdf39cd57a526ffd88007f96b176d68d69128c3d69e8"
    sha256 cellar: :any,                 x86_64_linux:  "868cfaf2b6ef06db3f6a52e6d3fb4c536583ac9be4d0b955299b00fd4d1ef4b6"
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
