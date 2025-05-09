class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "2cc39ec6faf4c5d4afd852b82766aed7fb39d58440009dcfdf9b1691434c1faf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa9932b6c6e88216c7636ccd919682af38d5f01372a1522d7ea2b3b0ca65f02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e584488213701a6aae7751fcb84edbfe6026cebdc0cd4a948664f191477f1aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "de84b7003cb68256073cdef002adc3315dbfed3a56788f4779118da3b4997515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "137bd3a98eadb83d2245b913c5db7cccd29ebdb3b8c88acab2b07f4ed2f13f78"
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
