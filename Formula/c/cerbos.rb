class Cerbos < Formula
  desc "Scalable, context-aware authorization service for applications"
  homepage "https://www.cerbos.dev/"
  url "https://github.com/cerbos/cerbos/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "6e3003c75078e6ccd19f8d9d9c71d65acb2a4ce8e5c494b92fe2bdb5fe1405c9"
  license "Apache-2.0"
  head "https://github.com/cerbos/cerbos.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed91a75dd22d389e00de2ae6c81438c730b7fb63c37c9be2e241f172d049a1d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "202bea74ff28fffbdefdc70ab445536dc71475456390ef0e12abe8759a4f9126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c675ff2bb585b33cf87c74c53204b20654749a2d292170e0b30d1d812f4b0b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23999c2ababda94a9c1edccd0d8a53ad4e7a9be936c11cdeac2a8d76c72017c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e68fe18f3ba88c42e7b13cabe876890f7e3763491918a04f733454f8ecd206"
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
