class CargoSpellcheck < Formula
  desc "Checks rust documentation for spelling and grammar mistakes"
  homepage "https://github.com/drahnr/cargo-spellcheck"
  url "https://github.com/drahnr/cargo-spellcheck/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1c3a80ab9cf604f605f4e3fb304acc529f68367edef7f0d041a871c371f6ebdd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drahnr/cargo-spellcheck.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60508f0187c8035db3f244defb684084ce71bf82b938eb33430a05f03edbc678"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165b5fbe46448f0f9a518c61d56d3c1c704358458e97324af5d7206cea09d2e5"
    sha256 cellar: :any_skip_relocation, ventura:       "4dad5c2f22ede6be6366e10e8ff2d02cec1c8184f1fa859262d423e9ce04335f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0ccd60b35eb8e5084b95efeda02871900d081174c97185a92e4cc4ca2866e7"
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
