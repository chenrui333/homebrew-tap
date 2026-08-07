class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/1.0.0.tar.gz"
  sha256 "3b5a10dbf835a2764091172d21d636582e2cfaebf0cb3d581245a092aea5793b"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3ee951d8a8af57af73ef6d612bb6f8813d59b010f596e45d204db55c2e66a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6edd77a6d61ba7d484fa25a2d77274ddbefc80e5eb14b295f9eac380d6b23b1"
    sha256 cellar: :any_skip_relocation, sequoia:       "2111330bc215b0e53d33493bb066b9d26628e68be553348f8e2181b68d036cf0"
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
