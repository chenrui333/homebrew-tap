class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v5.0.14.tar.gz"
  sha256 "708716cdf34c07f593f70946b0a2767431cfbba7e9b45ab22f8cb2b94192db4a"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a61f3ac9d6ab39498af0bb320df8dd912430892ce2d86327585fe0103712e414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61f3ac9d6ab39498af0bb320df8dd912430892ce2d86327585fe0103712e414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9579b3da6b6dba36c16b8415b57664084e3e4b3e3de0ab6342680e505aaf8b5e"
    sha256 cellar: :any,                 x86_64_linux:  "bcc91003faef75e0fe4554fea434566f85a4f2d97c4eac7865fdb9969f9bd866"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # vaults3 is an S3-compatible server; the test queries its loopback health endpoint.
  allow_network_access! :test

  def fetch
    cd "web" do
      system "npm", "ci"
    end
    system "go", "mod", "download"
  end

  def install
    cd "web" do
      system "npm", "run", "build"
    end
    (buildpath/"internal/dashboard/dist").mkpath
    cp_r "web/dist/.", "internal/dashboard/dist"

    ldflags = %W[
      -s -w
      -X main.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vaults3"), "./cmd/vaults3"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vaults3-cli"), "./cmd/vaults3-cli"
  end

  service do
    run [opt_bin/"vaults3"]
    keep_alive true
    working_dir var/"vaults3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaults3 --version")

    port = free_port
    config = testpath/"config.yaml"
    config.write <<~YAML
      server:
        address: 127.0.0.1
        port: #{port}
        shutdown_timeout_secs: 1
      storage:
        data_dir: #{testpath}/data
        metadata_dir: #{testpath}/metadata
    YAML

    pid = spawn bin/"vaults3", "--config", config.to_s,
                out: (testpath/"server.log").to_s, err: [:child, :out]
    # Retry actual readiness rather than assuming a fixed startup duration.
    output = shell_output("curl --silent --show-error --fail --retry 10 --retry-connrefused --retry-delay 1 " \
                          "--retry-max-time 15 --max-time 2 --noproxy 127.0.0.1 http://127.0.0.1:#{port}/health")
    assert_equal "ok", JSON.parse(output).fetch("status")
  ensure
    if pid
      begin
        Process.kill "TERM", pid
      rescue Errno::ESRCH
        nil
      end
      # Reap the owned child even if graceful shutdown fails.
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 3
      begin
        until Process.waitpid(pid, Process::WNOHANG)
          if Process.clock_gettime(Process::CLOCK_MONOTONIC) >= deadline
            Process.kill "KILL", pid
            Process.waitpid pid
            break
          end
          sleep 0.1
        end
      rescue Errno::ECHILD
        nil
      end
    end
  end
end
