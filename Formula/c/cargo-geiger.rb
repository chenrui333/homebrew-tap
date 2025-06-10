class CargoGeiger < Formula
  desc "Detects usage of unsafe Rust in a Rust crate and its dependencies"
  homepage "https://github.com/geiger-rs/cargo-geiger"
  url "https://github.com/geiger-rs/cargo-geiger/archive/refs/tags/cargo-geiger-0.12.0.tar.gz"
  sha256 "8318108bfc6a5058134483faab45e9bf9d42f0b98bdf24b5ff42d41b7e060540"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f846f472e9592f435fff9d49e9f1b96abb13e7fc10c9e4f6a74353a8f830eaee"
    sha256 cellar: :any,                 arm64_sonoma:  "1f22c185b2210eee4500a11a8f1fdec2027380d140fd5155fbed21471371f690"
    sha256 cellar: :any,                 ventura:       "7688626505856f1bb932e97542abf4da06d9ef4f335aef81bb270a254ae0480e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962dc15597774753c8c68751c1dd3839b0cba4950f6e3548fe81e4b9a644a8de"
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

    system "cargo", "install", *std_cargo_args(path: "cargo-geiger")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/cargo-geiger --version")

    # does not work with newer versions of Cargo, upstream bug report, https://github.com/geiger-rs/cargo-geiger/issues/530
    # mkdir "brewtest" do
    #   (testpath/"brewtest/src/main.rs").write <<~RUST
    #     fn main() {
    #         unsafe {
    #             let _a = 42;
    #         }
    #     }
    #   RUST

    #   (testpath/"brewtest/Cargo.toml").write <<~TOML
    #     [package]
    #     name = "test"
    #     version = "0.1.0"
    #     edition = "2018"
    #   TOML

    #   system "cargo", "build"
    #   output = shell_output("#{bin}/cargo-geiger --offline", 1)
    #   assert_match "1 warning emitted", output
    # end

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-geiger", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
