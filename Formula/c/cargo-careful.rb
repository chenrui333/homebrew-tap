class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "fa822e2a0eec050af6c3ee59db02b896a66339594fa0e6f67dff532bb5bdc2fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e20b15935950bd2bcb7f7ee2f6ad6eaa291b039f834a8074bea7b219f67499a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3cca766eb0bcce833c66fda1c78b6825035d21083bf92a388b74104d0f506b"
    sha256 cellar: :any_skip_relocation, ventura:       "eaf49573d90c10f3ec07cc704fb0d29fdb0856f78d372a32897be4d714dd9d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14beaa165c482f235a4845efc7373901ff34f458d1b5fc9f4a2504cb878e3d82"
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
