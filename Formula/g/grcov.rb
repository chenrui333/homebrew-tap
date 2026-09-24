class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "f9d1b3c6ced52d47b0d5d54ecaf40c6512144ac8c1b825fe6762495dfaad74d3"
  license "MPL-2.0"
  head "https://github.com/mozilla/grcov.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fcf909ebd81b741f3f5f90fb5eac5c17a2dd88e90ed44cc9d4bfe5d4058f0cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967c25a6f965b75721ff17d61812e691621501748b49df98dbf8026e1cbf67d0"
    sha256 cellar: :any,                 arm64_linux:   "026954ad2263bf708e12566baad53817854d9dfa4e4985d645fb5f382e222c38"
    sha256 cellar: :any,                 x86_64_linux:  "a14fbf5eacc955bde7ea9b172d4b9b32161a0075389a2bae3eadd15d5a14a5e3"
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
