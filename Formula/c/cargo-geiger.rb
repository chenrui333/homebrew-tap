class CargoGeiger < Formula
  desc "Detects usage of unsafe Rust in a Rust crate and its dependencies"
  homepage "https://github.com/rust-secure-code/cargo-geiger"
  url "https://github.com/geiger-rs/cargo-geiger/archive/refs/tags/cargo-geiger@v0.11.7.tar.gz"
  sha256 "6ddc447b0b8a46ee2b303897fbe2d416df794942cd23984c44b0ee69c4675bad"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  patch do
    url "https://raw.githubusercontent.com/chenrui333/homebrew-tap/ceb0ef84f4d34b992c0f20da279467c06c2590c7/patches/cargo-geiger/0.11.7.patch"
    sha256 "5dde9965fc849e263d4be0a7d3ba317dd829ad3b37f3d67e0359613c9f617271"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cargo-geiger")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/cargo-geiger --version")

    mkdir "brewtest" do
      (testpath/"brewtest/src/main.rs").write <<~RUST
        fn main() {
            unsafe {
                let _a = 42;
            }
        }
      RUST

      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"
      TOML

      output = shell_output("#{bin}/cargo-geiger --offline")
      assert_match "1 warning emitted", output
    end

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-geiger", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
