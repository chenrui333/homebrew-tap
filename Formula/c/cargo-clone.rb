class CargoClone < Formula
  desc "Cargo subcommand to fetch the source code of a Rust crate"
  homepage "https://github.com/JanLikar/cargo-clone"
  url "https://github.com/JanLikar/cargo-clone/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "b1df67690ac60ea184c54ffdf1bcf7ab8e3ab9dd9552ad70b4723109cf340718"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/JanLikar/cargo-clone.git", branch: "master"

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
