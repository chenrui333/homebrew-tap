class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "6e3003c75078e6ccd19f8d9d9c71d65acb2a4ce8e5c494b92fe2bdb5fe1405c9"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "314194652e923c6bdd903c29abeae2e54212287472b2e72a461a31db034bb875"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db75186839f14c09d4df85620b47110f4ae49d652582cf80e7695a9908801c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12d0cc12bcbca12998379aaa46e4e10defe0c485284562f27ecaf5bf8b45a4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e377b2e6d2accd9eb9b554203cd7c56d590c02c5f419217239f44bad6b4ed6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63eb9d5f0a254efc8f3bb4dd4087860be801417f8b609b45c6547911681203e5"
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
