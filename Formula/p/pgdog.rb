class Pgdog < Formula
  desc "Automatic sharding for PostgreSQL"
  homepage "https://pgdog.dev/"
  url "https://github.com/levkk/pgdog/archive/7e63ac492be1784db772ac1180a3f70c207e9b40.tar.gz"
  version "0.1.0"
  sha256 "153a0d5089b0e3deb123aa248802bc0b0c6a0d29710befc5bb8a5306269094eb"
  license "AGPL-3.0-only"
  head "https://github.com/levkk/pgdog.git", branch: "main"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d2a04b006ab3a58a3eddba4815de2a429f3402b7f9a24fdd8a3ac7ba8f6bf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "596d623a069d26b1ca3463a549f701d3fda99448fa0af7c9e978587df74ee35a"
    sha256 cellar: :any_skip_relocation, ventura:       "ddaf67d03b285050da4c147ce99f7179aa61be5398efaae61d784a2e522f1f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bca9caed9f75c30693f1c1be41913851c4ed7d32d8a32480c5c4f721169e57a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    system "cargo", "install", *std_cargo_args(path: "pgdog")
  end

  test do
    sql = "CREATE TABLE test_table (id SERIAL PRIMARY KEY, name TEXT);"
    output = shell_output("#{bin}/pgdog fingerprint --query \"#{sql}\"")
    assert_match "eab97bf582f0c0c9 [16913686169960628425]", output
  end
end
