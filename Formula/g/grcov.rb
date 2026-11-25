class Grcov < Formula
  desc "Rust tool to collect and aggregate code coverage data for multiple source files"
  homepage "https://github.com/mozilla/grcov"
  url "https://github.com/mozilla/grcov/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "6f100a2ee25dcbf49662044d1c8151010b497b4d57b18a792c0dc54dec896e50"
  license "MPL-2.0"
  head "https://github.com/mozilla/grcov.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fcf909ebd81b741f3f5f90fb5eac5c17a2dd88e90ed44cc9d4bfe5d4058f0cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967c25a6f965b75721ff17d61812e691621501748b49df98dbf8026e1cbf67d0"
    sha256 cellar: :any,                 arm64_linux:   "026954ad2263bf708e12566baad53817854d9dfa4e4985d645fb5f382e222c38"
    sha256 cellar: :any,                 x86_64_linux:  "a14fbf5eacc955bde7ea9b172d4b9b32161a0075389a2bae3eadd15d5a14a5e3"
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
