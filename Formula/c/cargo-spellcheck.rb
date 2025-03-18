class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "ab4027dea18ac252b1a3ad733f47899daa50dde3c90aa34f5f22534745f853d7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04418caf0756928e4064408c6b6243ce880763a40a08f941f79791c7e140aa53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9799c59eedf0ea92006cbdf6fbd2166a5c7a4fd28d1deb678074691aea2abbd6"
    sha256 cellar: :any_skip_relocation, ventura:       "195c20af8fc9684b253b73cc2a6bca9e8152c5b43a4a38f27f56ee735e5276a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b2da5719688a6bc58918ad5c31b77143a45c485ca28a4255af74291a0fbe85"
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
