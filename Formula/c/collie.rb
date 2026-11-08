class Collie < Formula
  desc "Mobile web interface for the coding agents in your terminal"
  homepage "https://github.com/AltanS/collie"
  url "https://github.com/AltanS/collie/archive/refs/tags/v1.28.0-edge.2.tar.gz"
  version "1.28.0-edge.2"
  sha256 "fc0e549447c12b28701ddff505e86528bc3598d6f2d99d8286cfd4c2df631033"
  license "MIT"
  head "https://github.com/AltanS/collie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "36c8f675724d31a929de588602772f0e7a5752da65a48f63600db71a03f536b6"
    sha256 arm64_sequoia: "d3bf965b329537a51ed75f78f75bb8a34603ad7379bd3655d4b7f7e484bede2e"
    sha256 arm64_linux:   "97f9b75278f9e1890b2a11f94510f72a2422fbc9706d25f84c1882312bf27460"
    sha256 x86_64_linux:  "3395291aed7e0eeda716850051cd959fd2303a113f7dc617b742d629819bd081"
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
