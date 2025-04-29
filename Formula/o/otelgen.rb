class Otelgen < Formula
  desc "Generate synthetic OpenTelemetry logs, metrics, traces via OTLP"
  homepage "https://github.com/krzko/otelgen"
  url "https://github.com/krzko/otelgen/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c8b609c2fd6b77a6782f8b42c9f1f269551632492c662b8b54859b9b067a631a"
  license "Apache-2.0"
  head "https://github.com/krzko/otelgen.git", branch: "main"

  depends_on "go" => :build

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
