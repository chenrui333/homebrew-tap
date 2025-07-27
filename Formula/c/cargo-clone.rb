class CargoClone < Formula
  desc "Cargo subcommand to fetch the source code of a Rust crate"
  homepage "https://github.com/JanLikar/cargo-clone"
  url "https://github.com/JanLikar/cargo-clone/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "58e86bd3440fc103572f6d8ff20ff1f99cf1e676cddb29975f204a9cb03f5b14"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/JanLikar/cargo-clone.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "aac5603a816b3b7883409edf85040c73d9ef70f970ea900afa2093e9cdef350a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc91e5db640d59dd32541b6a311601b1740d7710c0e8b85457a57011cf8592c9"
    sha256 cellar: :any,                 ventura:       "b3ffa2a748845e9c3980777d2849a6f19640a759c07865f3d136a8ac08d409d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf5dedb7f46b7b7c79840c0651ab121ef036cfc0dc151982a7f06fcda88b134"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "openssl@3"

  uses_from_macos "curl"
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
