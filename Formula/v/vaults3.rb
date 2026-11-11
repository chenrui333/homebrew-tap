class Vaults3 < Formula
  desc "Lightweight, S3-compatible object storage server with built-in web dashboard"
  homepage "https://github.com/Kodiqa-Solutions/VaultS3"
  url "https://github.com/Kodiqa-Solutions/VaultS3/archive/refs/tags/v5.0.16.tar.gz"
  sha256 "8bc7bc0091177601acac6928d78c8b946ae388bc82de01fa720e92279f4df5d1"
  license "AGPL-3.0-only"
  head "https://github.com/Kodiqa-Solutions/VaultS3.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce84d9fe970ec313bd696902da7537bd629068fad784b052127dfd2ef6d53ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce84d9fe970ec313bd696902da7537bd629068fad784b052127dfd2ef6d53ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8727fc56059e859287462c83de5c0c08cceba5911a12c1a7444348dca11b8840"
    sha256 cellar: :any,                 x86_64_linux:  "f77add64c18805369d30a5a7a3d9a6df968ec58f63304fb0f5aaa2bb36bc7365"
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
