class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/0.4.0.tar.gz"
  sha256 "a660afb4c60b21e8f79c54e4424f042491977bdbc0c29e23cf9bf891272eb240"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8b63afcd15276299f56a332abe456acd35f7f98f525df11f88242bf705eb20c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5637e76bfa4ab1f7fbe8e69cb696046b05272cc263b87b7e0d30b44d7074ecb9"
    sha256 cellar: :any_skip_relocation, sequoia:       "3e72518b19b1ae7149b4e2e6782983b7486ba64991d13ed52903c6e2c4b99247"
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
