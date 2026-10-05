class SilverSurfer < Formula
  desc "Kubernetes objects api-version compatibility checker"
  homepage "https://devtron.ai/"
  # GitHub regenerated the v0.1.4 archive (same tag commit); pin the tag commit
  url "https://github.com/devtron-labs/silver-surfer.git",
      tag:      "v0.1.4",
      revision: "cb3cad6347f97cd61f2b8ce015ca1a3432cfac19"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "824f9641d763487393d27de9ee7ba457bd96a8ad1fbff87aeb3644e24763baad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824f9641d763487393d27de9ee7ba457bd96a8ad1fbff87aeb3644e24763baad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824f9641d763487393d27de9ee7ba457bd96a8ad1fbff87aeb3644e24763baad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7680840f933a78d9c4b62edbec0ad92c72eabe31332cd69835bd7be89132cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff73b7e663fefefff804fb015637db0a2499547677f1d3c796922e2ed717550"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/silver-surfer --version")

    (testpath/"cm.yaml").write <<~YAML
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: demo
    YAML

    # Air-gapped mode reads Kubernetes OpenAPI schemas from local files instead of downloading them
    output = shell_output("#{bin}/silver-surfer --target-schema-location missing.json cm.yaml 2>&1", 1)
    assert_match "open missing.json: no such file or directory", output

    (testpath/"swagger.json").write "{}"
    output = shell_output("#{bin}/silver-surfer --target-schema-location swagger.json cm.yaml 2>&1", 1)
    assert_match "invalid info: value of version must be a non-empty string", output
  end
end
