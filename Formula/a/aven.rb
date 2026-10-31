class Aven < Formula
  desc "Local-first task manager for power users and agents"
  homepage "https://github.com/raine/aven"
  url "https://github.com/raine/aven/archive/refs/tags/v0.1.52.tar.gz"
  sha256 "caf6b5a3fdf6803ae10120984ee609c4c75fb90be27111005f5ecc1ce0d10480"
  license "MIT"
  head "https://github.com/raine/aven.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ebb55bd83255caf910c0fa9028b26f6992736b79a71705e80e22c3dcd5d1591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e16aa40cd3cb532fe7cdad0f775df85aad109fa64ba45d7cf09bb81adcc60147"
    sha256 cellar: :any,                 arm64_linux:   "84fd1e034a401953d4461d387578b7585407d78f932bf9f501d5dfefd73fbdd7"
    sha256 cellar: :any,                 x86_64_linux:  "794a49b830b70aa9eb7a49c7a96d2b22f21efd0d0e7c7efb6e420611f47ea5c9"
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
