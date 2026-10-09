class GlabTui < Formula
  desc "Terminal interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui.git",
      tag:      "v0.9.3",
      revision: "8eda7444376f10085b9796d650c9b44f029006d7"
  license "MIT"
  head "https://github.com/rcieri/glab-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cfe1f956fd621c0ffeb1759d550361e735f27906267637b91afd0d5e8c98841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a431e49d04a1dc8aa7b9ec0e51a77b7e61fb005f9b220a3bd78da8269255aff8"
    sha256 cellar: :any,                 arm64_linux:   "1eb473e88e224a7365ab8af4004343920b6cbae45802667b314fa9f22b565771"
    sha256 cellar: :any,                 x86_64_linux:  "e616e19cb1acea8019e83a262e3f3dac75df8c68177f63a742ec3b1f55300c92"
  end

  depends_on "rust" => :build
  depends_on "gh"
  depends_on "glab"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
