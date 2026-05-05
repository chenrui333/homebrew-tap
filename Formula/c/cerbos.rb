class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "f473be16e1ef96f8ee71f137995d0e35cb1d759d2e50dd0ffece3decd4c2a51b"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e275e46830a8ca6a7b4f2efc08ce4886afa9f2cb775136db0c9debeaeab2614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca37b4e8ec2a90f8e722a977c5fe6857fb550ca5229755543bc6cec1ef088a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8cfa64c44e6dd1860fb92ed39a617381803536652b9294eb60ab20d10afa4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14918fc5ae41c27082082db4fe6e99928eb50c7f0eafd8cb9606fcfd97e0cce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebf9cf2ef7d9a9cfb550a97d66c6cd7cf5573edd48c4bbd663d576bff8a1fb9"
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
