class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "212f1edad44d16946299ef8ac3298cf628748b6a2357fcc5b047c14327cf73fa"
  license "Apache-2.0"
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8afb4eef51fc85215eeafcda7dbe5672c95dfaf537a8f86693130b084d36d78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8afb4eef51fc85215eeafcda7dbe5672c95dfaf537a8f86693130b084d36d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8afb4eef51fc85215eeafcda7dbe5672c95dfaf537a8f86693130b084d36d78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130452e2122e73834ad5e72f7af3fb170447afa82cd79267f0a9e16309c05430"
    sha256 cellar: :any,                 x86_64_linux:  "9a00b9e1349e423a957d3128daf299d00f361c7ca4aec4ab0032db53946cfdf7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/c3x"

    generate_completions_from_executable(bin/"c3x", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c3x --version")

    output = shell_output("#{bin}/c3x not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
