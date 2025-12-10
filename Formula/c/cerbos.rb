class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "0f7263f080bcf3fcdf94580f20265fa10797c3c0f720de21ce396f08cc75a251"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb5a4169da7f714f0c526378a075645ee337c15c3b647206bde8c1d402b2c1ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c9d791a028080255098fa627e1e8656f38a8371fc892c5131bab222901d918b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e24fc2de935c4568b4155c88b999b3c99498127a1b76ef080fcc01b002a1f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1634a5e1b8ecd87e0576b77b9ddd67c54bdba4bfcc3bc7da428680b65ab97a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c32d9dd87733542e389a71575a25baa0723ff81cdf257503b271f66541e85873"
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
