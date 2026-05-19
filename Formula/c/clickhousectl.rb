class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "677126470b828b471177a16ac519c61b5f185cd23683ef799e9030adca06a975"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc1b17266d8162324d460ece128f3fd3998b800a1d7434b060e6b591bdb0b395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e44930b67cffd08bde93dddaf8ec9f68b4e477a0c550f74d108307d836fec43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f2238e29b08cffae13ff53ea8a24e04d83c04d3130b90a419ffc51b6a12370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc5cf0aca8b2690fa5af4540c63d0dbe4f5dc8d69ab171151ef5d28a7312d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de7a3e91ac3524d6bcce6a83d2dd9e2b3287bf83a58a7af2d0e3d4c854dc01a"
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
