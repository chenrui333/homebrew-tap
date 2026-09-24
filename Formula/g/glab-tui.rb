class GlabTui < Formula
  desc "Terminal interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d13a33eaa8729e127ba0eb83491a65cd1161cde89d37d9ae7273171f2d8ae7a1"
  license "MIT"
  head "https://github.com/rcieri/glab-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4ca88348ba1df89f8d1609b6d20bf7aa8806d04f6e30a6dc41aa02070d5acd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0453032092ce8e3ec8b63b2b417613373bd1467f4b639f4939ea4cb31a4aeb98"
    sha256 cellar: :any,                 arm64_linux:   "f277c1f8b262d985fa40f497f596c2fdd27bec4b049921de8d7b5cc9c5028bf8"
    sha256 cellar: :any,                 x86_64_linux:  "acb835fe4b24c66b9d45ef0f4df12a5c198735526add36bb3af13cd5c000b180"
  end

  depends_on "rust" => :build
  depends_on "gh"
  depends_on "glab"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glab-tui --version")
    output = shell_output("#{bin}/glab-tui repos")
    assert_match "Recent repositories:", output
    assert_match "(none)", output
  end
end
