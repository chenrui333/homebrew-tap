class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "24b9df4db9edf18b27e3d032b9f83dcef9c78bd446ae6a00a0fae02618478a05"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c247c065f44d71a3d0c6ddc36a59db361d66c240af131b16de0f98761a12bcb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c09c9ec9830e8e53276b7cbd8334d806ca31a3d19ce96780e74eea38875b2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a063f8ac21e02d4211ec1d09d14802ba00a810bc04eccb4f9ac2c2748257091f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050dacdce664d066482f6d82961c1d4f703f615f2eba4bdd8c90d8c4c45085e8"
    sha256 cellar: :any,                 x86_64_linux:  "507876a86a18f00ef32545871ba1f7483a2be55faf628ac740e2e056584d9797"
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
