class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "07f5702eb6a984bb6ff794e257cf6c680991d2f98aa5b02776a1a119501fdaa5"
  license "Apache-2.0"
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7121e0a75f7b01629001698a0ce682c5d3764d1995518be1643ff612763c01b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94008b850d75539e1dd6dbce4b7dac743213c0c2b9475202e00f4cd78ae8eb43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf46414894b3f740d4e9b92f93434444827d8d49f796dbfc1538d080c44e378c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ac1870faad1601a02e787b99f0756226f50a5c5f64b3cb0a0b9dc6f928b3e4"
    sha256 cellar: :any,                 x86_64_linux:  "edea912fc9ec2baf568a743b71c6e6bfb5f4a185164d175ee75b2cc09f0f78d9"
  end

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

    output = shell_output("#{bin}/c3x not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
