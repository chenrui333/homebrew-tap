class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/0.6.0.tar.gz"
  sha256 "02217f134d73c81375e02cafdb74c2620caddf78a8b81a5ad4f2d24b8d17938b"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a3f55f82977c44349674db7ed82941561239b4043ccdb6d6e81111ae815b688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc41f74dc4c73ff9f07603ae2c48d6500644ebf1c92c81f89221103c53216b0"
    sha256 cellar: :any_skip_relocation, sequoia:       "8507a8e408b4a277cbd200199980b598e35db989022f1232a8fcbf6f1d5de728"
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
