class Collie < Formula
  desc "Mobile web interface for the coding agents in your terminal"
  homepage "https://github.com/AltanS/collie"
  url "https://github.com/AltanS/collie/archive/refs/tags/v1.29.0-edge.1.tar.gz"
  version "1.29.0-edge.1"
  sha256 "3a87ace881739b2f4b89a4fbeebc9706afedae4d72ad52cbd76839a87aabd398"
  license "MIT"
  head "https://github.com/AltanS/collie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "28e665703e96901c6332e785a1fe3f62599280d3d4126aa96be64e2cb6d2b7aa"
    sha256 arm64_sequoia: "1711d55ecd8e2ef38226893e4035fdd39345828bc38b15bb2b78ec305a12b144"
    sha256 arm64_linux:   "2e340ed81e8e8b786054f80bacc27cd7a9373893661ea99ded354de298c75685"
    sha256 x86_64_linux:  "2fe562ad78e0ed2d9574e7a30275804bf0a4006db456e1c0934b321a9703fa05"
  end

  depends_on "typescript" => :build
  depends_on "bun"
  depends_on "herdr"

  on_linux do
    depends_on "icu4c@79"
  end

  # Bun appends its compiled JavaScript payload to the executable.
  skip_clean "share/collie/bin/collie"

  # Dependencies are prefetched; the test exercises the loopback bridge.
  allow_network_access! :test

  def fetch
    inreplace ["package.json", "bun.lock"], '"@types/bun": "latest"', '"@types/bun": "1.3.14"'
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    cd "web" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts", "--backend=hardlink"
    end
  end

  def install
    system "bun", "scripts/release-version.ts", "--tag", "v#{version}", "--stamp"
    ENV["COLLIE_BUILD_TIME"] = "1970-01-01T00:00:00.000Z"
    tsc = formula_opt_bin("typescript")/"tsc"
    system tsc, "--noEmit"
    system tsc, "--noEmit", "-p", "tsconfig.contract.json"
    cd "web" do
      system tsc, "--noEmit"
      system tsc, "--noEmit", "-p", "tsconfig.worker.json"
      system "bun", "run", "build"
    end
    system "bun", "run", "build:cli"
    # A production install does not prune an existing development tree.
    rm_r "node_modules"
    system "bun", "install", "--frozen-lockfile", "--production", "--ignore-scripts"
    pkgshare.install "bin", "bridge", "cli", "docs", "scripts", "systemd", "node_modules",
                     "package.json", "herdr-plugin.toml"
    (pkgshare/"web").install "web/dist", "web/src"
    (bin/"collie").write_env_script pkgshare/"bin/collie", COLLIE_PLUGIN_ROOT: pkgshare
    (bin/"collie-bridge").write <<~SH
      #!/bin/bash
      export COLLIE_PLUGIN_ROOT="#{pkgshare}"
      exec "#{formula_opt_bin("bun")}/bun" "#{pkgshare}/bridge/index.ts" "$@"
    SH
    chmod 0755, bin/"collie-bridge"
  end

  service do
    run [opt_bin/"collie-bridge"]
    environment_variables COLLIE_HOST: "127.0.0.1", COLLIE_SKIP_SERVE: "1"
    keep_alive true
    log_path var/"log/collie.log"
    error_log_path var/"log/collie.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/collie --version")
    port = free_port
    pid = spawn({ "COLLIE_HOST" => "127.0.0.1", "COLLIE_PORT" => port.to_s,
                  "COLLIE_SKIP_SERVE" => "1", "COLLIE_ACCOUNT_WINDOWS" => "",
                  "COLLIE_WALKY" => "0" }, bin/"collie-bridge",
                out: (testpath/"bridge.log").to_s, err: (testpath/"bridge.log").to_s)
    begin
      output = shell_output("curl --retry 20 --retry-connrefused --retry-delay 1 --retry-max-time 25 " \
                            "--connect-timeout 1 --max-time 3 -fsS http://127.0.0.1:#{port}/api/health")
      health = JSON.parse(output)
      assert_equal true, health.fetch("ok")
      assert_equal version.to_s, health.fetch("version").split("+", 2).first
      assert_match "<html", shell_output("curl --silent http://127.0.0.1:#{port}/")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
