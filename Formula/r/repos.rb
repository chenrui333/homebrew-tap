class Repos < Formula
  desc "Manage multiple Git repositories with an interactive terminal UI"
  homepage "https://github.com/epilande/repos"
  url "https://github.com/epilande/repos/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "30c2f524e3ec96a393d316327ab5eb0e48d160f2d782bf2a6febee9348a09d88"
  license "MIT"
  revision 1
  head "https://github.com/epilande/repos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "2a45d2dafc750e9b5ac46073822699e2d115cc485839b9470ea9067a7bb6515f"
  end

  depends_on "gh"
  depends_on "homebrew/core/bun"

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--production", "--cache-dir", buildpath/"bun-cache"
  end

  def install
    libexec.install "bin", "bun.lock", "node_modules", "package.json", "src", "tsconfig.json"
    bin.install_symlink libexec/"bin/repos"
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
