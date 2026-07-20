class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "d0efde4ddfbfca02ce57388d9dbd95ed1ba1efd91a4d32b9898695e8cf65383f"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8a8a22f64de3f216f675d19b53a2513cdbe8838156b1681ce0fb396181f3d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "123243048bd768382e54c43d53213670b00f77241befcc10c38a498178df9bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac37fe63a1f38b4bb26d489c3ab5ad19077e4a46385ec8be702a7ba5efa991d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6da5538e9ba43f9aebda6501996c002d846957a6ff770a01ddc2815e6caf8ed"
    sha256 cellar: :any,                 x86_64_linux:  "0ce8c757312b2f36b07a8794152c2e030a15869e86c7d976a252127202251c8f"
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
