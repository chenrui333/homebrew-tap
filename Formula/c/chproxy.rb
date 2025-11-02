class Chproxy < Formula
  desc "Open-Source ClickHouse http proxy and load balancer"
  homepage "https://www.chproxy.org/"
  url "https://github.com/ContentSquare/chproxy/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "15e312ee1fc6e13cb7f7c85255fe370d0701bb5d540c5a5fd41d01691c0c2b11"
  license "MIT"
  head "https://github.com/ContentSquare/chproxy.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildTag=#{version} -X main.buildRevision=#{tap.user} -X main.buildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chproxy -version")

    config = testpath/"config.yml"
    config.write <<~YAML
      server:
        http:
          listen_addr: ":9090"
          allowed_networks:
            - "127.0.0.1"
      clusters:
        - name: default
          nodes:
            - "http://localhost:8123"
      users:
        - name: default
          to_user: default
          to_cluster: default
    YAML

    output_log = testpath/"output.log"
    pid = spawn bin/"chproxy", "-config", config, [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Loaded config:\nserver:\n  http:\n    listen_addr: :9090", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
