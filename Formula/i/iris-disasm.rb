class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/0.2.0.tar.gz"
  sha256 "1ae447640978dd8657c6193809f9dd82b4c8a0e82a75ef45629c8e515c80ec5d"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/iris"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iris --version")
    assert_match "iris", shell_output("#{bin}/iris --help")
  end
end
