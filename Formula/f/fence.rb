class Fence < Formula
  desc "Lightweight sandbox with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "78a98ff08b1ec2589b261798750db4d48862beb845ba9f3fcdebc4275a8a21d3"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4698f19cb6dbcc244e437ed1941f61a276d9f4d2d9e5382a7abb2a38fd9e8ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4698f19cb6dbcc244e437ed1941f61a276d9f4d2d9e5382a7abb2a38fd9e8ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4698f19cb6dbcc244e437ed1941f61a276d9f4d2d9e5382a7abb2a38fd9e8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7827efd45df0cd7f14f89396978da6b2c67fa2ca474a5f01886d1c57207b4ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16ab161c85172438cad78a2b538c89efb773cc1a5da4f93aafe39944175aeb2b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601} -X main.gitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    output = shell_output("#{bin}/fence --list-templates")
    assert_match "Available templates:", output
    assert_match "code", output
  end
end
