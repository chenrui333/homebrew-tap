class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "26902308c2ce9fbd5d3e83cacd6083d332f2384227ca824c663b59219750a7f2"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94717d3c64f82ccd10dd092ae3c6cc6018fba389aee7d7e685c56aa96b4af1c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c774f6f1c359d87cfb323c3ccc30a7b48bab384ebf1b1ad04edec979fe1423bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995526e22e9bd1d5fe57c065a718cc47f391347d4875b19f795216a09793c651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ee2109f0723cf08490f64865aa79f700949f629234cfa747918d5f83925fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9eac1363a4f366003a0c3f851c98fec06317bcf21d257f3f27e0eb08d333e1"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "component", "add", "llvm-tools-preview" # for `llvm-profdata`

    assert_match version.to_s, shell_output("#{bin}/grcov --version")

    (testpath/"src/lib.rs").write <<~RUST
      pub fn add(a: i32, b: i32) -> i32 {
        a + b
      }

      #[cfg(test)]
      mod tests {
        use super::*;
        #[test]
        fn test_add() {
          assert_eq!(add(2, 3), 5);
        }
      }
    RUST

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2018"

      [lib]
      path = "src/lib.rs"
    TOML

    # Enable LLVM-based coverage instrumentation
    ENV["RUSTFLAGS"] = "-C instrument-coverage"
    ENV["LLVM_PROFILE_FILE"] = "cargo-test-%p.profraw"

    # build and test to generate coverage data
    system "cargo", "build"
    system "cargo", "test"

    system bin/"grcov", ".", "-s", ".", "-t", "lcov", "--llvm", "--branch",
           "--binary-path", testpath/"target/debug/deps", "-o", "lcov.info"

    # check on the coverage report
    assert_path_exists testpath/"lcov.info"
    assert_match "SF:", (testpath/"lcov.info").read
  end
end
