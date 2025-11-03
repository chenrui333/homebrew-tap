class GitlabCiPipelinesExporter < Formula
  desc "Prometheus/OpenMetrics exporter for GitLab CI pipelines insights"
  homepage "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter"
  url "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "fd8036e36aad3178339b180ddf65e960602250e48d596f633e8a45d384c70fb5"
  license "Apache-2.0"
  head "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gitlab-ci-pipelines-exporter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-ci-pipelines-exporter --version")

    (testpath/"config.yml").write <<~YAML
      gitlab:
        url: https://gitlab.com
        token: FAKE_TOKEN
      projects:
        - id: 123456
      metrics:
        listen_address: ":9252"
    YAML

    output = shell_output("#{bin}/gitlab-ci-pipelines-exporter validate -config #{testpath}/config.yml 2>&1")
    assert_match "level=info msg=configured gitlab-endpoint=\"https://gitlab.com\" gitlab-rate-limit=1rps", output
  end
end
