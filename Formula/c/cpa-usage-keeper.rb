class CpaUsageKeeper < Formula
  desc "CliProxyAPI usage tracker with SQLite storage and a web dashboard"
  homepage "https://github.com/Willxup/cpa-usage-keeper"
  url "https://github.com/Willxup/cpa-usage-keeper/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "cb4182e4b1837ef92b928c65d1ac8bd54751b91bce5e7978291bf8cd0c99679f"
  license "MIT"
  head "https://github.com/Willxup/cpa-usage-keeper.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f9fa4e63bc06656e5aa0624093a11a7a84953117b29d1b71ee09286960014d1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35c3b7b09590481d7418f94917714a58207674866a2470a316378e363d29cefc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee0d4e79c8d79c5ca19848cd9211564bd3143c995d1b70d90d766dac4b2de1b"
    sha256 cellar: :any,                 arm64_linux:   "f6af34a78e9776c7731123a519a43069d924e553e4fc5741fc4b4ccab1a2cb4b"
    sha256 cellar: :any,                 x86_64_linux:  "89a6a5b5abae6018bf8705ceceaf8eb7d8dc611bcfada6933aa25781fa632154"
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
