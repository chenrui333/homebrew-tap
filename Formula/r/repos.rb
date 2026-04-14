class Repos < Formula
  desc "Manage multiple Git repositories with an interactive terminal UI"
  homepage "https://github.com/epilande/repos"
  url "https://github.com/epilande/repos/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "83084c251e9ad14547e3bd3ee8d1975b9887ef31e85383657d97460aaa2b3027"
  license "MIT"
  head "https://github.com/epilande/repos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d0ddebc2ec304bc776fa42c4290c8df86db2f69db59b5aea8a9a5daa91936b61"
    sha256                               arm64_sequoia: "460869e1d851fea42f7613807b08bfd8f5795ca001a22573d833f1d125723c3b"
    sha256                               arm64_sonoma:  "872288b526bd7877cbfb1a6b2df67d4ff3217d54717f9b4972efe326b9666e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "132a6c5f2c9405fad66214cb834c33fe04749ddd9563475f5a4ad0486c6ac4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af262e73d3b0c002455461e87be9a0f446ad05241b9d3602248eba9bbd13786"
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
