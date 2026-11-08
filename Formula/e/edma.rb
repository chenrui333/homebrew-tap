class Edma < Formula
  desc "Terminal interface for embedded databases"
  homepage "https://github.com/chungquantin/edma"
  url "https://github.com/chungquantin/edma/archive/refs/tags/v0.1.0-beta.5.tar.gz"
  sha256 "77dfc5bf718b952b900f2693c862cbb365274daf99690ab29a2c783ed371b41c"
  license "MIT"
  head "https://github.com/chungquantin/edma.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3fe31ea4b3f99b9abcbccf9dc587f778a09c5ffe7cc6b669cd2fa8bddd89f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7937d22c3ad620c763aa74628ced5fe5dc6c5f09ac1c813a3163eea0a7f94d4f"
    sha256 cellar: :any,                 arm64_linux:   "ae8df38538faca98f5dce1e3dc31d285c46a36f789b002c74dd8e420ad4ed7fb"
    sha256 cellar: :any,                 x86_64_linux:  "eeceec5f85ef1ab636346144c064eef3203aa88cbee0010c5c1e62194da44639"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The release lockfile predates upstream's libclang-compatible binding update.
    # https://github.com/chungquantin/edma/commit/d9df17af392d0013bbc4f9a4e8c2152455052210
    system "cargo", "update", "-p", "librocksdb-sys", "--precise", "0.8.3+7.4.4" unless build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm")
    # RocksDB 7.4 relies on integer-type includes that GCC 13 no longer provides transitively.
    ENV.append "CXXFLAGS", "-include cstdint" if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "gui")
    pkgshare.install "gui/config-example.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/edma --version")
    (testpath/"invalid.json").write("not JSON")
    output = shell_output("#{bin}/edma --config-path #{testpath}/invalid.json 2>&1", 101)
    assert_match "Unable to parse", output
  end
end
