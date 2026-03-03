class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "5c4a236133f6982a4ea6588f0b1a9c0cc5838be50cb533da2023344b198120df"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d96652efa25728f803e0ef98851d893cb04b018f9960f8230d457ad040c6c40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faae4af4a94000127fe2256c379c8201d6aa41fa68fda993bbb3a41eef49363e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14c706802b223e2b3231d5e490c81253d537df1567e9f51272b043dcf583e691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820063cb204029dd9cd82976dd20e2790b39dd355a003923485398d5a86d2580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6280d1a65ff8c25609add6d4b2469d0b9fa8f0041b6a20160f3a285cb4e01319"
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
