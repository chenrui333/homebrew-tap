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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235da38e07d5902d68467d2b7f95676287185b8e3c59a9c5bca4e3800780743a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "235da38e07d5902d68467d2b7f95676287185b8e3c59a9c5bca4e3800780743a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f40f5825435fff7e0104da73fc5462c185d09c9809760a101e5a24b28c541bf"
    sha256 cellar: :any,                 x86_64_linux:  "5bc8b5c9d0a357a2c68439aaf1ce12af8da9ed936d36597f3c8f75fbc8852864"
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
