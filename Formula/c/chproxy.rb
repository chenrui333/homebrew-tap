class Chproxy < Formula
  desc "Open-Source ClickHouse http proxy and load balancer"
  homepage "https://www.chproxy.org/"
  url "https://github.com/ContentSquare/chproxy/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "15e312ee1fc6e13cb7f7c85255fe370d0701bb5d540c5a5fd41d01691c0c2b11"
  license "MIT"
  head "https://github.com/ContentSquare/chproxy.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de53f9539d01a2e53e4ae1f67987ae7b2e9f6a160835429e0eb1e096e27772ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de53f9539d01a2e53e4ae1f67987ae7b2e9f6a160835429e0eb1e096e27772ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de53f9539d01a2e53e4ae1f67987ae7b2e9f6a160835429e0eb1e096e27772ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1616156c391384ef0c810331a2d6625db964e633ca589dc922907c2777c1c34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33032495781f625672a2de056e030830a9d7011eeea712de13a2f087dfed6c95"
  end

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
