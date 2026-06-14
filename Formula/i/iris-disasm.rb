class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/0.2.0.tar.gz"
  sha256 "1ae447640978dd8657c6193809f9dd82b4c8a0e82a75ef45629c8e515c80ec5d"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40be7b3a67bb92a2d91fd112743a2b14ff3502ce4db5fa8bb87728b0daa9544d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33d841f62887ef51673a1db000fb473d80d8e4e59c2891c49255bc89a8455650"
    sha256 cellar: :any_skip_relocation, sequoia:       "50bdc42ee5609b87064ceedb0229b2efcbdcb927cfb0f409ff035348f89ca55c"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/iris"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iris --version")
    output = shell_output("#{bin}/iris --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
