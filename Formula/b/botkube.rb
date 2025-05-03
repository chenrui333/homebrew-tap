class Botkube < Formula
  desc "CLI for botkube"
  homepage "https://botkube.io/"
  url "https://github.com/kubeshop/botkube/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "ca637b3a18ea8a398eba0e2b498c9c0c91f6c31a4529bd7ae54d4ae4e3fc6928"
  license "MIT"
  head "https://github.com/kubeshop/botkube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf34e240d7f3905536fdb26dda167e7c234293efce310b85b59d1ad2e72e1390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b8633944f7fb056aef519080b62fa046a3ad6b5f43299df5692de537b359bc"
    sha256 cellar: :any_skip_relocation, ventura:       "db43ed25f9ebebb997281503812a0442aeb43197e11c86ce0962b4f22e515eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c8ef5414ba6b8d495eed9bd54953f4d9ed036e2652f5b64812a61d61eecd32"
  end

  depends_on "go" => :build

  def install
    # -X github.com/kubeshop/botkube/cmd/cli/cmd/migrate.DefaultImageTag={{ .Env.IMAGE_TAG }}
    # -X github.com/kubeshop/botkube/internal/cli/analytics.APIKey={{ .Env.CLI_ANALYTICS_API_KEY }}
    ldflags = %W[
      -s -w
      -X go.szostok.io/version.version=#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit=#{tap.user}
      -X go.szostok.io/version.name=botkube
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"botkube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/botkube version")

    output = shell_output("#{bin}/botkube config get 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
