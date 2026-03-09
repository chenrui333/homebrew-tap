class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "5c4a236133f6982a4ea6588f0b1a9c0cc5838be50cb533da2023344b198120df"
  license "MPL-2.0"
  head "https://github.com/mozilla/grcov.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "379dbda4d0f659aad832b20ca93df93fe523ae7bc4d6efec71db5afa31b4c03c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a58dc893fe2b28709bba70145b1f2117c1010c543aaf8f447cc3ce524b7bf45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf414476ef24bce119264fdc0ea9d0aa80890ffad26aee7ca5b198fab0b0d2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15a373d42d79cdf0b494222e4c01f138cf32295b1328bfe14dc14c8155e5e269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a7f5d5b0d11997aaf2a3774dfbc1b207d6767a9994527fd7accd4b8af9ce79"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
