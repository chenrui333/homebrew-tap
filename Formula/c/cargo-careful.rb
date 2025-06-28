class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "fa822e2a0eec050af6c3ee59db02b896a66339594fa0e6f67dff532bb5bdc2fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa5c375dcba00a47eac371297d3e61b4042e583e96d95a539b36db2447ca01d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c47bf35fca0d911ccaa0523fae49f278fdfcdd5c226cc3ced8c6c5bd19607c8"
    sha256 cellar: :any_skip_relocation, ventura:       "4de9c0cc8e80102d3ee0a4d0dfc25485289b2444492ea04f6c45ce3b04f04daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356f3336195dd98d003bbb22f00b30002ec312351fb8caafc67497cfaea3647b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-careful"
      version = "0.1.0"
      edition = "2021"
    TOML

    system "cargo", "careful", "setup"
    output = shell_output("cargo careful run")
    assert_match "Hello, world!", output
  end
end
