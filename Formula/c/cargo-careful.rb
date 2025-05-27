class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "0c4e7320e7139a5a817edfc3ed0cdd1053fa39f2aa1a83d3228afede3246d37b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb0942e74dd1299bf6355ab49af75fb24cf03b9a0f2705250b19cbef721eee99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce35053647a7ca4b4055f2d4a44f32fbccd086b935523ff9adc5baf936d573a3"
    sha256 cellar: :any_skip_relocation, ventura:       "404598d7fd3cecfe0bbea40ed3dc33012cd2a90dd4de6a00caaaccb4543ce3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8df3e194e3ce75c02803cf8df5d7188b1564cd0617c996f58c7bca58233724b"
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
