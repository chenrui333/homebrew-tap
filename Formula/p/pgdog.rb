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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f7675eb10a52c59fc20bae7236d910af7af7845670221c92af2259ab587137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1583f041a99922a46a322cb4530f5007a73135fe6b844e4eb9021481549d0ff"
    sha256 cellar: :any,                 x86_64_linux:  "c51a60fec3203f027feac568cc279351d2796f06db1299e46962f399e10fbc3b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang, used by `pg_query` bindgen

  deny_network_access!

  def fetch
    # Upstream gitignores Cargo.lock; resolve once during fetch so the build stays offline.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
