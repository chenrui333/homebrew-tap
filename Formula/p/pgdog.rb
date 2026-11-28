class Pgdog < Formula
  desc "Automatic sharding for PostgreSQL"
  homepage "https://pgdog.dev/"
  url "https://github.com/pgdogdev/pgdog/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "c91a93af3ac49233bca54d62cc0b4b9cf6a8dad46fd314126a56eb38cf3fb600"
  license "AGPL-3.0-only"
  head "https://github.com/pgdogdev/pgdog.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f7675eb10a52c59fc20bae7236d910af7af7845670221c92af2259ab587137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1583f041a99922a46a322cb4530f5007a73135fe6b844e4eb9021481549d0ff"
    sha256 cellar: :any,                 x86_64_linux:  "c51a60fec3203f027feac568cc279351d2796f06db1299e46962f399e10fbc3b"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@79" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "llvm" => :build # for libclang, used by bindgen
  uses_from_macos "perl" => :build

  on_linux do
    depends_on "readline" => :build
    depends_on "zlib-ng-compat" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    if OS.linux?
      # Use Homebrew's toolchain instead of the upstream Linux image's clang and mold.
      inreplace ".cargo/config.toml", <<~OLD, <<~NEW
        [target.x86_64-unknown-linux-gnu]
        linker = "/usr/bin/clang"
        rustflags = ["-C", "link-arg=--ld-path=/usr/bin/mold"]

        [target.aarch64-unknown-linux-gnu]
        linker = "/usr/bin/clang"
        rustflags = [
            "-C",
            "link-arg=--ld-path=/usr/bin/mold",
            "-C",
            "target-feature=+lse",
        ]
      OLD
        [target.aarch64-unknown-linux-gnu]
        rustflags = ["-C", "target-feature=+lse"]
      NEW
    end

    system "cargo", "install", *std_cargo_args(path: "pgdog")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgdog --version")

    sql = "CREATE TABLE test_table (id SERIAL PRIMARY KEY, name TEXT);"
    output = shell_output("#{bin}/pgdog fingerprint --query \"#{sql}\"")
    assert_match "eab97bf582f0c0c9 [16913686169960628425]", output
  end
end
