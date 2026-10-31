class Aven < Formula
  desc "Local-first task manager for power users and agents"
  homepage "https://github.com/raine/aven"
  url "https://github.com/raine/aven/archive/refs/tags/v0.1.52.tar.gz"
  sha256 "caf6b5a3fdf6803ae10120984ee609c4c75fb90be27111005f5ecc1ce0d10480"
  license "MIT"
  head "https://github.com/raine/aven.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "4aca3493f0b75706d3f5b96ed2710aabfe241246c4946790f696f91a6d1df65d"
    sha256               arm64_sequoia: "61b84ef11c35248a9ab0b6799a516d0a6374b89ab5bafa0d63e9a9bf769a5c06"
    sha256 cellar: :any, arm64_linux:   "477e5d6c8634a26fba309cd85e8fb79b2382f752f57388d724f5da63519bb6ef"
    sha256 cellar: :any, x86_64_linux:  "d3cdacce5f20021a951fd1b3cb4d420ad9f8b19b3ee3ac48abf8d4a73f2dfae9"
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
