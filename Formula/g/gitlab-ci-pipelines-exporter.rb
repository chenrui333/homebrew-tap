class GitlabCiPipelinesExporter < Formula
  desc "Prometheus/OpenMetrics exporter for GitLab CI pipelines insights"
  homepage "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter"
  url "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "fd8036e36aad3178339b180ddf65e960602250e48d596f633e8a45d384c70fb5"
  license "Apache-2.0"
  head "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bea7fac4e40b3462c28cb4cf34c1773ce58e0f301d0239cc7d41217989483610"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea7fac4e40b3462c28cb4cf34c1773ce58e0f301d0239cc7d41217989483610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bea7fac4e40b3462c28cb4cf34c1773ce58e0f301d0239cc7d41217989483610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a8754cf324c5b69d3dc1e55bd7ac669c250cd0a738332ffe67502e3f1cc8831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb348f9c1db5016a2ea8095614bdc64a4838783fdc190489ff0a8011fb875b1"
  end

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
