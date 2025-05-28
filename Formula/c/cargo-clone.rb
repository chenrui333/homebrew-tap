class CargoClone < Formula
  desc "Cargo subcommand to fetch the source code of a Rust crate"
  homepage "https://github.com/JanLikar/cargo-clone"
  url "https://github.com/JanLikar/cargo-clone/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "58e86bd3440fc103572f6d8ff20ff1f99cf1e676cddb29975f204a9cb03f5b14"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/JanLikar/cargo-clone.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "3c70399221e3d3b32a7a3c698ee24993f051f9ac8b0c682e2bfc124ea4c647d1"
    sha256 cellar: :any,                 arm64_sonoma:  "35021dd5d224761273dffd53767f733c37f9cd4fb9868ebf91268a904e000b7c"
    sha256 cellar: :any,                 ventura:       "4b866449f2101ea7053cfaa471535d8f38d84992091a5371c23658815926bfc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9802c0d6dc309e126aefa26fdb003f99cf525e68be89c3c0f76576bf385212"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cargo-clone")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    require "utils/linkage"

    system bin/"cargo-clone", "clone", "git2"
    assert_path_exists "git2/Cargo.lock"

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-clone", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
