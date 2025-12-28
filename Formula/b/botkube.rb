class Botkube < Formula
  desc "CLI for botkube"
  homepage "https://botkube.io/"
  url "https://github.com/kubeshop/botkube/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "ca637b3a18ea8a398eba0e2b498c9c0c91f6c31a4529bd7ae54d4ae4e3fc6928"
  license "MIT"
  revision 1
  head "https://github.com/kubeshop/botkube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f118f252797351183b508265d49c2dd27cd72e8b462ac9e7f87e155c9c431902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71cf9ca9409b876a982bd8378319190814187dce2e0cb0e37900d03d2387366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ea79b73f83c1dcce8473397a3ecaf69ae9aa8e6a76d81e2c10e3c83862c414d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f434fc390dd4e3ad94c8d4c1fc4edc8e06a17565a89acc05e5b18a1f7f21e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3d699f85a4e6437a508562fa8569f2e5e082765eb52128a6eabd3194db25f2"
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

    generate_completions_from_executable(bin/"botkube", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/botkube version")

    output = shell_output("#{bin}/botkube config get 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
