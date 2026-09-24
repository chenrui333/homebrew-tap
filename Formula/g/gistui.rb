class Gistui < Formula
  desc "Terminal interface for GitHub Gists"
  homepage "https://github.com/akunzai/gistui"
  url "https://github.com/akunzai/gistui/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "c2b7f4dd4bbc731a0863124cfe4e978857cfb2241e7c3f4f86e631b6e2c5e88f"
  license "MIT"
  head "https://github.com/akunzai/gistui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "237b7f9fdd23d4807b94cb8384d2b0c40da377dbbc5db80da9dca0a5e5f421c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f2b94d6e5f691c918ef1e873bbd7459dc37818aa3d4881fcbccbded0a6f92b"
    sha256 cellar: :any,                 arm64_linux:   "bfc4c1286afc8190e5b9dc4a7350a21387925dd7f68970dcc5c6a321308ef00c"
    sha256 cellar: :any,                 x86_64_linux:  "76ce6733896d6ae05b5a3203bdd8406f671ccffbfa8866a4e438462fe9ea861a"
  end

  depends_on "rust" => :build
  depends_on "gh"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gistui --version")
    output = shell_output("#{bin}/gistui #{testpath}/missing 2>&1", 1)
    assert_match "path does not exist", output
  end
end
