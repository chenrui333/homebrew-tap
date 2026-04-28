class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "87b7221f4cd2cae70d5fa05d0333b62ca1a90d4018c14d28334fecda20b39285"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16f14f2386692394b894f4601819178d9f43dcae5daac3daa8bc647a8e38e87f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2177a948494beb5c52674134f3d6b4e1922ad412bce2c2fd9245ed21c27de74d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f07defafe047c9444d30c543069f65ad5e368776c024f751622f23e87dfa86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6804c270b8477379ef1ea1d381fcdd0a9a51ab10b6a28213b242baebfddd7b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2de417a7e1a92b859a66b2b89ab4e8a50b17ec841f5eed618a728f1a688501"
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
