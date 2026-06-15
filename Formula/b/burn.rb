class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "cc4aa76e1c667b9a1f50af73b8638c8a7e9d09d1ac3fa5cb7bed57bd9d78457f"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "508d2a816fd4eb68733d2c08a88753ea6f7a04ed7506134e561ae8d891bf4859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508d2a816fd4eb68733d2c08a88753ea6f7a04ed7506134e561ae8d891bf4859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "508d2a816fd4eb68733d2c08a88753ea6f7a04ed7506134e561ae8d891bf4859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85c0b190e22bb4190d5b65261ab606cc7134390458b35798a3caac84962532aa"
    sha256 cellar: :any,                 x86_64_linux:  "d036785c34bf2229c572de6443742e03c3e39294075f8e38b932b020221240e9"
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
