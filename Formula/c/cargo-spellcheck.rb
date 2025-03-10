class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "04f22f2f3448ac73d36790f2551a63948e09090a7756a82640d778d769b49eb3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0794365de2edf764d4c18fdb191be3e272f967d08e9f79749193b6a461705318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeef901bb73d9262d4ef59c7fcbe56e696ab42a27bf67970fb7c7081a168dd65"
    sha256 cellar: :any_skip_relocation, ventura:       "02b32f38f4f8f8d601af41a4a9665ee99f2be8e22b9851d9826fb878df67d0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5215c4e6d5db988f9587338a9bc0e5c838eed3e26c3e199ae6dff073f316673b"
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
