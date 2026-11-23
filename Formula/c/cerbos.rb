class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "8159cda2f11571317fbc7f522a067cfb61299d6338f93298e4973c8a952af709"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "da90d0050a5551dea801e22543d4460b3247617f2f4bd940df97b8c8def65ec1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea49a80cd51203ca3387b77a78a1ea9e1f76c0ca6ff8ae08a115565791b983d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba1500c17b7efb8618f6328a6d59b8c6ab05d8b83d788fcb8e0a6bdb877974b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56be7538b8b7ce014c8d3a5d1135a456900973cb2440ed9146090b049ed4db45"
    sha256 cellar: :any,                 x86_64_linux:  "71fca63fb9ca2510f8ad7d6675cb0c82de1e04cd0eba8ac63f9da8fc268ccc06"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
