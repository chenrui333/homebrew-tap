class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "2ee369804991b35b4407e84868b00811bd19d01eda25cfeee5e7126dd11aac81"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "251aa3bab55fe6b7d37a6410e7e83e8d8e64e2d753e7d8d9847627f1e1b533b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d383481f05b1109d870aed98034bdd8b62a6389f6c5236dab03c6abc74fdf6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5354292d9598913894c52d9e9943c0287f85f0ac8cfce5efd56793db4c83a431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2affced1057b3fc212902ed36a200554e8827914eece726595096bce2ae632b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e89eefc8b7843bd74c449532ea10557edf8ab7b1782a0d98f8f338e0486f88"
  end

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
