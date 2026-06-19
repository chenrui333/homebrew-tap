class Zeroserve < Formula
  desc "Zero-config, fast io_uring-based HTTPS server"
  homepage "https://github.com/losfair/zeroserve"
  url "https://github.com/losfair/zeroserve/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "546f7e8631cf76476082e5c6083bfb1bc1f6fabd0e47a0eeb7ca575bd0da43c4"
  license "MIT"
  head "https://github.com/losfair/zeroserve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "6154ca8afeb43c4d74d6fd996cb46281c3d02c46544db802b2919fbe83278986"
    sha256 cellar: :any, x86_64_linux: "233bfa14f37cf8c919967ad66a2ddaa6cf8ad3c5e12a0d6ec7841f94544468d7"
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
