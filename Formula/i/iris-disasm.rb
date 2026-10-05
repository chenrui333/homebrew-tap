class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/1.0.0.tar.gz"
  sha256 "3b5a10dbf835a2764091172d21d636582e2cfaebf0cb3d581245a092aea5793b"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f985ee830e3e2563944c47a4b0284882a474d6a928332e51dffb7fe1eac97355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67e02164da121207399fcda3c52138c54eb79a2516b1befcdd242969435907b"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  deny_network_access!

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
