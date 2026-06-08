class Zeroserve < Formula
  desc "Zero-config, fast io_uring-based HTTPS server"
  homepage "https://github.com/losfair/zeroserve"
  url "https://github.com/losfair/zeroserve/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b0a911aa36fc641b6a36944c556d2af580dbfb52ad996b3dcf6a972fb5a8ff74"
  license "MIT"
  head "https://github.com/losfair/zeroserve.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroserve --version")
    assert_match "zeroserve", shell_output("#{bin}/zeroserve --help")
  end
end
