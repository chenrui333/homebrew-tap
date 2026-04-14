class Repos < Formula
  desc "Manage multiple Git repositories with an interactive terminal UI"
  homepage "https://github.com/epilande/repos"
  url "https://github.com/epilande/repos/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "83084c251e9ad14547e3bd3ee8d1975b9887ef31e85383657d97460aaa2b3027"
  license "MIT"
  head "https://github.com/epilande/repos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3f23bfdbc5cb79a2ce8e837182a1febc77a2f513083191ee63800c06633d83af"
    sha256                               arm64_sequoia: "bf45a4f87909fdda2e28fd2aa1787afa1c93ceaef5e932e37671030298170899"
    sha256                               arm64_sonoma:  "2711869e1289c0051b1416016bad3a7e1547fef3020f326dec2668f62aa1e5a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cadb16457a80c8f3b575facc0438728b161ebcbf3a517ca3830ac7242eb81dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc21802ae2af630b76f9885f6d2daf27ee82fa4cf7edd60e9ff8c4e38841d0ad"
  end

  depends_on "chenrui333/tap/bun" => :build
  depends_on "gh"

  def install
    system "bun", "install", "--frozen-lockfile"
    system "bun", "run", "build"

    bin.install "repos"
  end

  test do
    version_output = shell_output("#{bin}/repos --version").strip
    assert_equal version.to_s, version_output

    repo_root = testpath/"workspace"
    repo = repo_root/"demo"
    repo.mkpath
    system "git", "-C", repo, "init"

    output = if OS.mac?
      shell_output("cd #{repo_root} && script -q /dev/null #{bin}/repos status --summary")
    else
      shell_output("cd #{repo_root} && script -qec '#{bin}/repos status --summary' /dev/null")
    end

    cleaned = output.gsub(%r{\e\[[0-9;?]*[ -/]*[@-~]}, "").delete("\r").delete("\b")
    assert_match "Repository Status Summary", cleaned
    assert_match "Total: 1 repositories", cleaned
    assert_match "Clean: 1", cleaned
  end
end
