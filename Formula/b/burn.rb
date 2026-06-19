class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "01d6b279247574fcaa8f0b48a7675c2a247b63609efe022b2cb8ae04ee51c9f7"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07bee9cd13392e14f93d4b9d8bf7225aa76e7bf9bf77eb1dccb1cdb63d913beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07bee9cd13392e14f93d4b9d8bf7225aa76e7bf9bf77eb1dccb1cdb63d913beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07bee9cd13392e14f93d4b9d8bf7225aa76e7bf9bf77eb1dccb1cdb63d913beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e1cc16bd33e1067b6b20580755403d94ea490cc272201e8e6151b7ae6ce6d76"
    sha256 cellar: :any,                 x86_64_linux:  "351bca2e704b0907783d561a02243674ad8aa1a3b9e023cbfd6e9d4cce1de7b3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"

    generate_completions_from_executable(bin/"burn", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")

    output = shell_output("#{bin}/burn analyze --ai 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
