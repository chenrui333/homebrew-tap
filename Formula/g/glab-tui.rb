class GlabTui < Formula
  desc "Terminal interface for GitLab and GitHub"
  homepage "https://github.com/rcieri/glab-tui"
  url "https://github.com/rcieri/glab-tui.git",
      tag:      "v0.9.5",
      revision: "8b571f2608bda48816f3475fe9e37d4bfc33c11c"
  license "MIT"
  head "https://github.com/rcieri/glab-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6ad3fb1e4148fca9e773dacbee9b19f0bcd817c26786370f459dde3816af6a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6584f312e73f7a790ddc91d4c6fd7bd04f9f4bdda7bf708f4d51f8f0041b3366"
    sha256 cellar: :any,                 arm64_linux:   "cc30c94cf428127e872cf39e3d0079db4605945e1dc63a151e0d3eb7ef37d0a5"
    sha256 cellar: :any,                 x86_64_linux:  "f9bc899f638c4cc336f200ad8b135beb26fb98766bab9a12940d44f458519eaa"
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
