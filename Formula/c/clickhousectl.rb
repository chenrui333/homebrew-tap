class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "f3d1723b662b16a4e48555261e3abd8b235678df720cde531b2ed662fedec8f2"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf7ebe7d8265b0261eab00763e82d45d4975a6d79f126e533629562fd672b551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e8125ca5c74558fe78eea6292cd0dad30fbf03cb9a06e29c188d7196ea172c"
    sha256 cellar: :any,                 arm64_linux:   "45ec554c70b01d0508b90bc182057d3f8e16dc79d5c6708ec2af339423d6887e"
    sha256 cellar: :any,                 x86_64_linux:  "81314dee2af50e369c8af3ff5d9b1e3d1c95aa12f870d4779f7ecfbd812c55b1"
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
