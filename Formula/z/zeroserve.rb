class Zeroserve < Formula
  desc "Zero-config, fast io_uring-based HTTPS server"
  homepage "https://github.com/losfair/zeroserve"
  url "https://github.com/losfair/zeroserve/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b0a911aa36fc641b6a36944c556d2af580dbfb52ad996b3dcf6a972fb5a8ff74"
  license "MIT"
  head "https://github.com/losfair/zeroserve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "c78c40e87045cf3b5b9a7a431e403a5c0e49736f6a7d8b576e66a8ee8374187c"
    sha256 cellar: :any, x86_64_linux: "68ae966d9d93d776e0865483cb75db298cdd2aab6cc0ac9ce505028af41cbfa2"
  end

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
    output = shell_output("#{bin}/zeroserve --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
