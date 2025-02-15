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
