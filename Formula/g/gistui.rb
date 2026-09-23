class Gistui < Formula
  desc "Terminal interface for GitHub Gists"
  homepage "https://github.com/akunzai/gistui"
  url "https://github.com/akunzai/gistui/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "c2b7f4dd4bbc731a0863124cfe4e978857cfb2241e7c3f4f86e631b6e2c5e88f"
  license "MIT"
  head "https://github.com/akunzai/gistui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf1ef26b69eb382ad0f8f4469f0b607a748984aa4889294f017dfac5037fbb6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d8fd6da8786370aedd8637fa02c43f57d35622fa2eb68d5a71e146986fbd46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a134f9202550d39a523912757197484a0976df83e7dab53dce582edaeebb274d"
    sha256 cellar: :any,                 arm64_linux:   "f657653257304c440cb2ff18312aa3cf480e96c6fcc3460fbffd59dbc3a13d6d"
    sha256 cellar: :any,                 x86_64_linux:  "0d344780ba08db13896c8bb9361dbdc967ab5e5c6f3962069478813809fe71f2"
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
