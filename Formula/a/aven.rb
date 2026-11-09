class Aven < Formula
  desc "Local-first task manager for power users and agents"
  homepage "https://github.com/raine/aven"
  url "https://github.com/raine/aven/archive/refs/tags/v0.1.55.tar.gz"
  sha256 "6c72428818a0032e16ca9c85a2645130c4581028b958d1454e541d873edc805c"
  license "MIT"
  head "https://github.com/raine/aven.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a0895bfc4a6cf8843e22b7c210f0d20b898ea6e5b5bac1a4817833b0237468c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95287043e3bbde630834d7506ffae0422dabe6623197d55ee0a610ed3264943c"
    sha256 cellar: :any,                 arm64_linux:   "17eb3a8155719fad92052edf68491bf11724b2783603016befc9a90d39e33ece"
    sha256 cellar: :any,                 x86_64_linux:  "2f5d9999d7630966ad928d21a9bf9965d9937aa879683129b1464f71e28499d7"
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
