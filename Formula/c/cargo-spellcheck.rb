class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "8dadcc8f0ce102c6c179a1b7dbfa0c5e2ea135c557899707603ab62bba72f71a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80cb73e7f3ac8642ed2ca9597c49c803ceb7f6b7b4bb891157b21118cef5004e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be54c5f36d186f14cc5a5bc54bea7e8aafe477706e1b30189e65796967e6308"
    sha256 cellar: :any_skip_relocation, ventura:       "c56f6662bd68cbe7928308a4d887bd05c21a9bfc5894a4cbfee2c88c5ff2d893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82dfc847976da783ad3f86568b09a31cc18c60319a4281e7496ad35e57be5835"
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
