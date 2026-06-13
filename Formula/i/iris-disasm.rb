class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/0.2.0.tar.gz"
  sha256 "1ae447640978dd8657c6193809f9dd82b4c8a0e82a75ef45629c8e515c80ec5d"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4014a039a1b0fb840e9cf4acae954e7a7f25b7702443a4401508d4fe24a322c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09bb129101373183789d89e327c47c88e53aee0f80468060b15d6af916579a2e"
    sha256 cellar: :any_skip_relocation, sequoia:       "d4891b9087c79ba2dae92bece35d05c756527b08cf3f30cbc4249b23e2f6063b"
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
