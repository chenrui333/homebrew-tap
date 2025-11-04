class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "2ee369804991b35b4407e84868b00811bd19d01eda25cfeee5e7126dd11aac81"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cerbos/cerbos/internal/util.Version=#{version}
      -X github.com/cerbos/cerbos/internal/util.Commit=#{tap.user}
      -X github.com/cerbos/cerbos/internal/util.BuildDate=#{time.iso8601}
    ]
    system "go", "build", "-trimpath", *std_go_args(ldflags:), "./cmd/cerbos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cerbos --version")

    policy_dir = testpath/"policies"
    policy_dir.mkpath

    # Write sample resource policies
    (policy_dir/"document.yaml").write <<~YAML
      apiVersion: api.cerbos.dev/v1
      resourcePolicy:
        resource: "document"
        version: "1"
        rules:
          - actions: ["read", "write", "delete"]
            effect: EFFECT_ALLOW
            roles:
              - admin
          - actions: ["read"]
            effect: EFFECT_ALLOW
            roles:
              - viewer
    YAML

    (policy_dir/"comment.yaml").write <<~YAML
      apiVersion: api.cerbos.dev/v1
      resourcePolicy:
        resource: "comment"
        version: "1"
        rules:
          - actions: ["create", "update", "delete"]
            effect: EFFECT_ALLOW
            roles:
              - admin
          - actions: ["create"]
            effect: EFFECT_ALLOW
            roles:
              - user
    YAML

    output = shell_output("#{bin}/cerbos compile #{policy_dir}")
    assert_match "Test results", output

    output = shell_output("#{bin}/cerbos compile --output=json #{policy_dir}")
    assert_match "summary", output
  end
end
