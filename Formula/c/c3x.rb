class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "07f5702eb6a984bb6ff794e257cf6c680991d2f98aa5b02776a1a119501fdaa5"
  license "Apache-2.0"
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/c3xdev/c3x/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/c3x"

    generate_completions_from_executable(bin/"c3x", "completion", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c3x --version")

    output = shell_output("#{bin}/c3x --help")
    assert_match "AVAILABLE COMMANDS", output
    assert_match "estimate", output
  end
end
