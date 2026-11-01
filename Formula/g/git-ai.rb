class GitAi < Formula
  desc "Git extension for tracking AI-generated code in repositories"
  homepage "https://github.com/git-ai-project/git-ai"
  url "https://github.com/git-ai-project/git-ai/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "2aea77871e67720ef13b75c85b746e6d5a250083d3d11835726efe183d70a7cb"
  license "Apache-2.0"
  head "https://github.com/git-ai-project/git-ai.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Point upstream's Homebrew candidate at this installation's prefix.
    # Retain its existing executable and git-ai shim-recursion guards.
    inreplace "src/config.rs", '"/opt/homebrew/bin/git"', "\"#{HOMEBREW_PREFIX}/bin/git\""
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args, "--bin", "git-ai"
    (pkgshare/"skills").install "skills/ask", "skills/git-ai-search", "skills/prompt-analysis"
  end

  service do
    run [opt_bin/"git-ai", "daemon", "run"]
    keep_alive true
    log_path var/"log/git-ai.log"
    error_log_path var/"log/git-ai.log"
  end

  test do
    (testpath/".git-ai/config.json").write <<~JSON
      {"telemetry_oss":"off","disable_version_checks":true,"disable_auto_updates":true}
    JSON
    ENV["_GITAI_INTERNAL_DISABLE_WRAPPER_DAEMON_AUTOSPAWN"] = "1"
    assert_match version.to_s, shell_output("#{bin}/git-ai version")

    system "git", "init", "--quiet"
    (testpath/"example.txt").write "homebrew-attribution-fixture\n"
    system "git", "add", "example.txt"
    system "git", "-c", "user.name=Homebrew Test", "-c", "user.email=brew@example.com",
           "commit", "--quiet", "--author=Homebrew Test <brew@example.com>", "-m", "Initial fixture"
    ENV["GIT_AI_DAEMON_HOME"] = testpath
    ENV["GIT_AI_DAEMON_CONTROL_SOCKET"] = testpath/"control.sock"
    ENV["GIT_AI_DAEMON_TRACE_SOCKET"] = testpath/"trace.sock"
    daemon_pid = spawn bin/"git-ai", "daemon", "run",
                       out: (testpath/"daemon.log").to_s, err: (testpath/"daemon.log").to_s
    100.times do
      break if File.socket?(testpath/"control.sock") && File.socket?(testpath/"trace.sock")

      sleep 0.1
    end
    assert File.socket?(testpath/"control.sock")
    assert File.socket?(testpath/"trace.sock")
    output = shell_output("#{bin}/git-ai blame example.txt")
    assert_match "homebrew-attribution-fixture", output
    assert_match "Homebrew Test", output
  ensure
    if daemon_pid
      Process.kill("TERM", daemon_pid)
      Process.wait(daemon_pid)
    end
  end
end
