class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "618b250ef8b20abbc3832068d9b6f1e0e262108c03afe7a0226722b358d285f7"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf325c66ff69ec4f35e192f4ebe8b8f85c71382076289ea361b69868e2053e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e705a6cad627fe76596c064522fe2d4182993e3d6989f11f23accc4a73e77d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "514932a74eeb49fef0d77493bbad2e4df723fa4c67476cfe065fd3f8363c8dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7bbcbe6bc6a425e45f498b144c94bc689dc135eb1d62c8c6d12f472298eaa47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d0554fe5fb52af882ce70cb9b30ffee7b1497701c917b32e95adaeace75400"
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
