class Aven < Formula
  desc "Local-first task manager for power users and agents"
  homepage "https://github.com/raine/aven"
  url "https://github.com/raine/aven/archive/refs/tags/v0.1.53.tar.gz"
  sha256 "16d8bdbb1c4694b7b4d5b0faa5e02fcde8cc4f7e2494b80288c35dd37af94b6d"
  license "MIT"
  head "https://github.com/raine/aven.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "470a4c70658b6493c52d0ca66400955a9a4369a6642de305c28b517e9add11fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7604ae319594f6227be652e792174635443a6665e2ac32593d8e9686172d1a01"
    sha256 cellar: :any,                 arm64_linux:   "a4fe2a1e35064ffc3349f7e8fcdd8081f023fed800bce3e2f0e5ea7b5cc0dcff"
    sha256 cellar: :any,                 x86_64_linux:  "c74e7209f2019e6b510dc06f067f702e2af1e95a5724c15f62d397d623914b52"
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
