class CpaUsageKeeper < Formula
  desc "CliProxyAPI usage tracker with SQLite storage and a web dashboard"
  homepage "https://github.com/Willxup/cpa-usage-keeper"
  url "https://github.com/Willxup/cpa-usage-keeper/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "e8f77cb6dc93eac164bc23ea9404dec654b8ce0d1492a91311546dc3b0e2600d"
  license "MIT"
  head "https://github.com/Willxup/cpa-usage-keeper.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b261cd6e9e2c4d3191cf3c1119a84f0ac24ea1ddf8b7bc822f84915b2e82cfbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8665d96dae3f7619413261ca4506eccde3c973bb1d33619549dcb2008553f75"
    sha256 cellar: :any,                 arm64_linux:   "c11a710ff02791909b606615074be7467d54cb4997cd73573eab9cd6fe5bc905"
    sha256 cellar: :any,                 x86_64_linux:  "580eb62d9033b975abc0c8787f3e47f87696296118d9e8046bd2b8f037c596ac"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # The test starts a loopback server for the dashboard and health endpoint.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "web" do
      system "npm", "ci", "--ignore-scripts"
    end
  end

  def install
    cd "web" do
      system "npm", "ci", "--offline"
      system "npm", "run", "build"
    end
    # go-sqlite3 requires cgo; Homebrew enables it by default except on Linux ARM.
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ldflags = "-X cpa-usage-keeper/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
    inreplace ".env.example", "WORK_DIR=./data", "WORK_DIR=#{var}/cpa-usage-keeper"
    etc.install ".env.example" => "cpa-usage-keeper.env"
  end

  def caveats
    <<~EOS
      Set CPA_BASE_URL, CPA_MANAGEMENT_KEY and a private LOGIN_PASSWORD in:
        #{etc}/cpa-usage-keeper.env
      The service listens on loopback and stores its database under:
        #{var}/cpa-usage-keeper
      For manual runs, create that data directory before launching the server.
    EOS
  end

  service do
    run [opt_bin/"cpa-usage-keeper", "--env", etc/"cpa-usage-keeper.env", "--host", "127.0.0.1"]
    working_dir var/"cpa-usage-keeper"
    log_path var/"log/cpa-usage-keeper.log"
    error_log_path var/"log/cpa-usage-keeper.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpa-usage-keeper --version")
    port = free_port
    (testpath/"data").mkpath
    (testpath/"keeper.env").write <<~ENV
      APP_PORT=#{port}
      WORK_DIR=#{testpath}/data
      CPA_BASE_URL=http://127.0.0.1:#{free_port}
      CPA_MANAGEMENT_KEY=homebrew-offline-test
      AUTH_ENABLED=false
      BACKUP_ENABLED=false
      LOG_FILE_ENABLED=false
    ENV
    pid = spawn bin/"cpa-usage-keeper", "--env", testpath/"keeper.env", "--host", "127.0.0.1",
                out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      output = ""
      60.times do
        output = shell_output("curl --silent http://127.0.0.1:#{port}/healthz 2>/dev/null || true")
        break if output.include?('"status":"ok"')

        sleep 1
      end
      assert_equal "ok", JSON.parse(output).fetch("status")
      dashboard = shell_output("curl --silent http://127.0.0.1:#{port}/")
      assert_match "<title>KEEPER</title>", dashboard
      assert_match "/assets/", dashboard
      # Liveness can succeed before storage startup; verify the persistent store too.
      assert_path_exists testpath/"data/app.db"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
