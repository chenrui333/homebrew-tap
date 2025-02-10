class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "c6f6d8cd5acf3b9ef0ebc6755894d3e2fc18db5a3a79c55f0bfdb6284d7bbf4e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58bc78ca33ace41a7d631359260b566b1128636ad55c030b6d17783f5a41cad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79086404ea755424338fa807c71c374c86094cd411c20aec735113102352bbc6"
    sha256 cellar: :any_skip_relocation, ventura:       "4fcfa2fb403fa89ca170f18d0d1889abc93e678e5caedf07699345a07e677464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59fad1895735757f01f608f137dd8d9a6a94118d96639085aa519fc8fb0a77c"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "hunspell"

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}/cargo-spellcheck --version")

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      //! This is a simple libary with a deliberate misspelling.
      pub fn foo() {}
    RUST

    output = shell_output("#{bin}/cargo-spellcheck check #{testpath}")
    assert_match "libary", output
  end
end
