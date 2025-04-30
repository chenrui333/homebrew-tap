class Otelgen < Formula
  desc "Generate synthetic OpenTelemetry logs, metrics, traces via OTLP"
  homepage "https://github.com/krzko/otelgen"
  url "https://github.com/krzko/otelgen/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c8b609c2fd6b77a6782f8b42c9f1f269551632492c662b8b54859b9b067a631a"
  license "Apache-2.0"
  head "https://github.com/krzko/otelgen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f047c4424b62aae83539a1c262f2219a47b2e2e11373598c69ed4244f3e0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8222c4a33d57015f0020f399ed389596f36d4e261f89697ed45b146f0a7bdd00"
    sha256 cellar: :any_skip_relocation, ventura:       "b5c79aed356065f10ad36c16b09271031b3ceb03f1af15d556f81e2629771327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "849dfbf5ed0037775e0254686bb723613193b9e8359d66764a0fdc76385f3c73"
  end

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
