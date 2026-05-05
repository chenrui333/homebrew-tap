class Repos < Formula
  desc "Manage multiple Git repositories with an interactive terminal UI"
  homepage "https://github.com/epilande/repos"
  url "https://github.com/epilande/repos/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c6a4b1c3ca301c7754d5bb552d102fb08ab7f7166ddea43cfcbfe15572717f98"
  license "MIT"
  head "https://github.com/epilande/repos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "cd72a6b26762e0d300c4799409888cf666df3669b6a11bd6bb3aed28944e529a"
    sha256                               arm64_sequoia: "cd0bdfc60cbbb45c75bb542279afa37fe29571d52a9c8444935761494fea441c"
    sha256                               arm64_sonoma:  "3039ced9a712e8dd951a1f32d46037c21b42729b8b8dc80460b71f74b8860e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a3f86000563460da6ca371228aff627dbb23f1ff5453f05c8a9ea78a268843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "843b646db764827796d0f32a449e31e56b493da009d11e888382249c085a1312"
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
