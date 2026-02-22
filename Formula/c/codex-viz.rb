class CodexViz < Formula
  desc "Local-first dashboard for Codex CLI sessions"
  homepage "https://github.com/onewesong/codex-viz"
  url "https://github.com/onewesong/codex-viz/archive/96fcd16256a74849f670c464ba48bb261d34f952.tar.gz"
  version "0.1.0"
  sha256 "65688e5feac4b89540f2cee56e34cc78183f9cd2952d39e79c23d2e18a2ad68a"
  license "MIT"
  head "https://github.com/onewesong/codex-viz.git", branch: "master"

  depends_on "node"

  def install
    ENV["NEXT_TELEMETRY_DISABLED"] = "1"

    system "npm", "install", "--include=dev",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "run", "build"
    system "npm", "install", "--omit=dev",
           *std_npm_args(prefix: false, ignore_scripts: false)

    libexec.install Dir["*"]

    (bin/"codex-viz").write <<~SH
      #!/bin/bash
      export NEXT_TELEMETRY_DISABLED=1
      cd "#{libexec}" || exit 1
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/node_modules/next/dist/bin/next" start "$@"
    SH
  end

  test do
    assert_equal version.to_s, shell_output("node -p \"require('#{libexec}/package.json').version\"").strip

    sessions = testpath/"sessions"
    sessions.mkpath
    port = free_port
    pid = nil

    pid = spawn(
      {
        "CODEX_SESSIONS_DIR"  => sessions.to_s,
        "CODEX_VIZ_CACHE_DIR" => (testpath/"cache").to_s,
      },
      bin/"codex-viz", "-H", "127.0.0.1", "-p", port.to_s,
      out: testpath/"server.log",
      err: testpath/"server.log"
    )

    sleep 8
    assert_match "Codex Viz", shell_output("curl -fsS http://127.0.0.1:#{port}")
  ensure
    next unless pid

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
