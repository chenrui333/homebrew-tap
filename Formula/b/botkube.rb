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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94593646bba64289dcbbfd629335c488b239d060ed6c14496467aa2fbbd1c255"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fdf910bff18ceccf470f8403f4802d4b70dccebfd8bdde0d721a87b8455a9b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c232683b63e06642c08b1d8925cd8fa8c0f8f3d9be59024b8cb08971362e7a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09520b00cf5ecd0e82500f3374c62b495d91c19152904e532496fac3064e93e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8745775e8f60df06245943954a53daa7e51fac4420982a7882c0533d82caa94d"
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
