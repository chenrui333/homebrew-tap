class CargoCareful < Formula
  desc "Execute Rust code carefully, with extra checking along the way"
  homepage "https://github.com/RalfJung/cargo-careful"
  url "https://github.com/RalfJung/cargo-careful/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "b0cabb0d8576a7d6fb1070c9d0742cd98cbf84ebde7fdf8ea152f83b8a54da5a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/RalfJung/cargo-careful.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216e4276854d473d90f4c180fef7348cc5570ae32db0ec28f63a9747bcf289b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798e6cf75800104e4b4a929caae76eb5c266bc0ec12e81a3b61034ab9bf23a11"
    sha256 cellar: :any_skip_relocation, ventura:       "051ad22a8eb9a4c2a128722cb2d1c4ff88f1f75372bdba856626350c9b6faf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07b608cc8b75e5c40df2b6c4524e79a161c61533502c08bc5e1d62fe131c32d"
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
