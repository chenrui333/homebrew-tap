class Aven < Formula
  desc "Local-first task manager for power users and agents"
  homepage "https://github.com/raine/aven"
  url "https://github.com/raine/aven/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "053218a68885427b242460c4a989cf8de0658ebbe4da5f18e5193b630c5c81cf"
  license "MIT"
  head "https://github.com/raine/aven.git", branch: "main"

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
