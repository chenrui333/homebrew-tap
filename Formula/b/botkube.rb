class Botkube < Formula
  desc "CLI for botkube"
  homepage "https://botkube.io/"
  url "https://github.com/kubeshop/botkube/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "ca637b3a18ea8a398eba0e2b498c9c0c91f6c31a4529bd7ae54d4ae4e3fc6928"
  license "MIT"
  head "https://github.com/kubeshop/botkube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ecb7b51fa9b0665320c8417c2ad50bfe940bb15620f62f4567768768ca72d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0acfca2dc95ad006ae4decf71efdc18e090b1088ad80aab0fd67e559a26f2076"
    sha256 cellar: :any_skip_relocation, ventura:       "46a567e1a03c1b2a5aa598c9747b6b55459c78462f88c48a508be00457c56a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3013aaadf694204dbe328f49a959c4a2a017c1f88b7a58459ff39ed3df70a869"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubeshop/botkube/internal/cli/analytics.APIKey=
      -X go.szostok.io/version.version=#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit=#{tap.user}
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.name=botkube
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"botkube", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/botkube version")

    output = shell_output("#{bin}/botkube config get 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
