class GlabTui < Formula
  desc "Terminal interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui.git",
      tag:      "v0.9.4",
      revision: "5fb7fceca62afe25c8064c33d280e7eb8a2a8d95"
  license "MIT"
  head "https://github.com/rcieri/glab-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b37f47d3aaae5337fdeab5e36e4ec40b4cb45eccfe56d741b579e3f8be97422e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b49b759595adcea6b03f79e55587b5a14be03e855558e36429d863097ebe014"
    sha256 cellar: :any,                 arm64_linux:   "aa43c6b5a122bc16c67cea8283054f8e2807591c583f228a508d7b9d879a36d0"
    sha256 cellar: :any,                 x86_64_linux:  "82b00110970023ff466d8ed8b344518aeba8cc07744cf6252360b48e93776815"
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
