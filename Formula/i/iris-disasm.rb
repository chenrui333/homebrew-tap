class IrisDisasm < Formula
  desc "ARM64/ARM64E disassembler with semantic layer validated against LLVM"
  homepage "https://github.com/mi11ione/iris"
  url "https://github.com/mi11ione/iris/archive/refs/tags/1.0.0.tar.gz"
  sha256 "3b5a10dbf835a2764091172d21d636582e2cfaebf0cb3d581245a092aea5793b"
  license "Apache-2.0"
  head "https://github.com/mi11ione/iris.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e395df091c9bf426da843393746da9d94c8b03e18ed685764a0660ddbfee6b4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60d3d69ec0be889c377e586cd6c20e9b0cac0f69bbd5aca673f9ac526c915e0"
    sha256 cellar: :any_skip_relocation, sequoia:       "efedb60440444c71f8b6d0a0da2c3b71f929c3e307acd602a663ef0fb8333912"
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
