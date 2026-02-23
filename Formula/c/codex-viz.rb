class CodexViz < Formula
  desc "Local-first dashboard for Codex CLI sessions"
  homepage "https://github.com/onewesong/codex-viz"
  url "https://github.com/onewesong/codex-viz/archive/96fcd16256a74849f670c464ba48bb261d34f952.tar.gz"
  version "0.1.0"
  sha256 "65688e5feac4b89540f2cee56e34cc78183f9cd2952d39e79c23d2e18a2ad68a"
  license "MIT"
  head "https://github.com/onewesong/codex-viz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d234f1add68034fa1318b7fccf4863bfbadc1629e06b2629e8c398e72c1894c4"
    sha256 cellar: :any,                 arm64_sequoia: "33a37d9859406fea7dde206d9428895a47608fb08d02373e4f84a0b0c35269d0"
    sha256 cellar: :any,                 arm64_sonoma:  "33a37d9859406fea7dde206d9428895a47608fb08d02373e4f84a0b0c35269d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e6d9e3630b82b53e267d79d10d9b58134e754c46cbd123ca3086229f21db12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03cc0e0b7528db111efadbafc613e4e6067a30fe718e913a72919b0acfc1de1"
  end

  depends_on "node"

  def install
    ENV["NEXT_TELEMETRY_DISABLED"] = "1"

    system "npm", "install", "--include=dev",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "run", "build"
    system "npm", "install", "--omit=dev",
           *std_npm_args(prefix: false, ignore_scripts: false)

    libexec.install Dir["*"]
    if OS.linux?
      # Keep only glibc Next.js binaries to avoid musl-only `libc.so` linkage.
      libexec.glob("node_modules/@next/swc-linux-*-musl").each do |swc_musl|
        rm_r swc_musl
      end
    end

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
