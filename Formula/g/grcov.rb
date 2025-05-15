class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "cfecfc03f195ccc81b847a5b395f7f5435a4cc9417c64bf215a8867874b0ab87"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe93a685c47b417618cf263181eefcc1463c023979cb7bc5ba0fcb204966227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb548ba7f471e7be01c26a5747070d1ecf4cbb75df79ae88f1b00cc5cab9d6ef"
    sha256 cellar: :any_skip_relocation, ventura:       "dab07885e27b6615fa16120401280a35b39330d9fd90ac860213538b1ae7eff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59e190ab6f1189a096bb7cf06299cdde46b8466606c201b93ce24122ac85e89"
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
