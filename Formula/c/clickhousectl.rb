class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "8039ca4f7d03a31c22cb4b2c2705824f7f61b57d0f83ddae562499ab44887035"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e0709c3a9004564af4330d7f394e6ef0aa10b06b9455b580968f9b49beab003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b065c8e0510d37c40dc7583b5611674d5eceb91aac1bc63969fb32859ba7f0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2beca8a7ef1e502889789c0f661491dd492f7218f4191ec2187064996b5a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec63edcd4575df375fdf4199108ef375b42f5bacbaccff010a6c85d5c36691d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823beb2f545314c7b171a4ee10f58c248a14ef98a074b036b40c994382722377"
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
