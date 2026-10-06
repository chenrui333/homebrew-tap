class Otelgen < Formula
  desc "Generate synthetic OpenTelemetry logs, metrics, traces via OTLP"
  homepage "https://github.com/krzko/otelgen"
  url "https://github.com/krzko/otelgen/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c8b609c2fd6b77a6782f8b42c9f1f269551632492c662b8b54859b9b067a631a"
  license "Apache-2.0"
  head "https://github.com/krzko/otelgen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1167fc1393cdc18d7f7a103738889057dcf1e29d69182065ca3df8e015a6b5c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1167fc1393cdc18d7f7a103738889057dcf1e29d69182065ca3df8e015a6b5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ae3356c548dee758df6efd5ef0de02e24d546d75ac6c0642158c2c9f388078"
    sha256 cellar: :any,                 x86_64_linux:  "52de4361ed53bf45b6bbe017492808c06f49866595e4f2c6e842aa5df0f1d0c8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/otelgen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otelgen --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"otelgen", "--otel-exporter-otlp-endpoint",
                    "otelcol.foo.bar:443", "traces", "single",
                    [:out, :err] => output_log.to_s
    sleep 1
    assert_match "traces generation completed", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
