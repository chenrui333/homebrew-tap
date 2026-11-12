class Aven < Formula
  desc "Local-first task manager for power users and agents"
  homepage "https://github.com/raine/aven"
  url "https://github.com/raine/aven/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "837811db524200e0a841c1bdc99aec4c22208172157a788c528484e70d1329c3"
  license "MIT"
  head "https://github.com/raine/aven.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "accc67c9a17f4ca0db5fe3bb78ec2d1e4551cf1891dbf41aacadb8adb6c080c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf97a2bb1c74f6cb25ab1a03ff32444fdd4e1741c8225f80d3db9fdec9a27cda"
    sha256 cellar: :any,                 arm64_linux:   "0402e7f985be7ac4f899cd616de8f99f2aa3a67f3ebe172f23015fefa0178f03"
    sha256 cellar: :any,                 x86_64_linux:  "8ce2b1038aa433b3b84b760467e6575958df1fb20c48c6b1cf71144efc38ab02"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "skills"
    generate_completions_from_executable(bin/"aven", "completions")
  end

  service do
    run [opt_bin/"aven", "daemon"]
    keep_alive true
    log_path var/"log/aven.log"
    error_log_path var/"log/aven.log"
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/aven --version")
    system "git", "init", "--quiet"
    database = testpath/"tasks.sqlite"
    system bin/"aven", "--db", database, "add", "Homebrew task", "--priority", "high"
    tasks = JSON.parse(shell_output("#{bin}/aven --db #{database} list --all-projects --json"))
    task = tasks.find { |item| item.fetch("title") == "Homebrew task" }
    assert_equal "high", task.fetch("priority")
    system bin/"aven", "--db", database, "edit", task.fetch("ref"), "--status", "done"
    completed = JSON.parse(shell_output("#{bin}/aven --db #{database} show #{task.fetch("ref")} --json"))
    assert_equal "done", completed.fetch("status")
    assert_path_exists database
  end
end
