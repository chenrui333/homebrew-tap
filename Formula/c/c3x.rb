class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "07f5702eb6a984bb6ff794e257cf6c680991d2f98aa5b02776a1a119501fdaa5"
  license "Apache-2.0"
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "496f02d7247fbbe7dae7669e110b866d06bbbd5015be1e2fdf55e7908e32512b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01c2c6af1e85900208cfda598df9f438def7da81eba76de9cb96b75aeb301b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e37b8f01e8eabea3c998ad87bcbef066c1348266d9d3c8464a465c9d207c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80addd1433507d259d5ec7a76f2bceaa81a70d7f08f820b44a056614e3531629"
    sha256 cellar: :any,                 x86_64_linux:  "5383d05f2fc1d473b2a37a7d89abf6a31e25ad632eb6b9e8d4f764e039d2297d"
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
