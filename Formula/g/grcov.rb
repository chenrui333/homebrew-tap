class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "6f100a2ee25dcbf49662044d1c8151010b497b4d57b18a792c0dc54dec896e50"
  license "MPL-2.0"
  head "https://github.com/mozilla/grcov.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "00503a4f5f1fe802df203a1c8b00dd11372650bb7494210958c538e6e00530ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd9664e520b1d50c071787ce2a8211f2b32f1d9575bc0dc1d30e21f833106da8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b03a4f44d5cc6b2bcefd0eb94659156dedb629729b6e79ca36e4812bf64a097"
    sha256 cellar: :any,                 arm64_linux:   "0adb5453c2604be17b316f51bab53175b0386abb7f508bd497e007e3c981482a"
    sha256 cellar: :any,                 x86_64_linux:  "15543ff7117dde25d2bc149e247029a1c40ece5e0bbbd0285b3a3c31319e2622"
  end

  depends_on "rust" => [:build, :test]
  depends_on "llvm" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grcov --version")

    (testpath/"src").mkpath
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

    test_binary = testpath/"coverage-test"
    system "rustc", "--test", "-C", "instrument-coverage", "src/lib.rs", "-o", test_binary
    with_env(LLVM_PROFILE_FILE: (testpath/"coverage.profraw").to_s) { system test_binary }

    system bin/"grcov", ".", "-s", ".", "-t", "lcov", "--llvm", "--branch",
           "--llvm-path", formula_opt_bin("llvm"),
           "--binary-path", test_binary, "-o", "lcov.info"
    report = (testpath/"lcov.info").read
    assert_match %r{^SF:(?:.*/)?src/lib\.rs$}, report
    assert_match(/^DA:\d+,[1-9]\d*(?:,.*)?$/, report)
  end
end
