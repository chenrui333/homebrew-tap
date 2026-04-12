class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.36.tar.gz"
  sha256 "91d09974dac249dd3e2482c96c6a72702f8a6e2f726fcd7ec9d00f5a12bb85aa"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bb8fc6be0a87bea8d57214d8a70dc25c82f2453b95f9af100c9aeb4ea47a4d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb8fc6be0a87bea8d57214d8a70dc25c82f2453b95f9af100c9aeb4ea47a4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5cc8487aba3f915778cc35f85ca6ba64c69668f139a6fb7f5570905dd4c445c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e5005ce4cd1bd315cc5b03e89dcb673cbe12bed925d3273ee3a48c20ebe28fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edddd14b5b19747179e959787c7fa5eb7c8c86541436c1e1e12132e75bb84d11"
  end

  depends_on "go" => :build
  depends_on "go-task" => :build
  depends_on "node" => :build

  def install
    system "task", "deps:fe", "build:fe"

    ldflags = %W[
      -s -w
      -X github.com/semaphoreui/semaphore/util.Ver=#{version}
      -X github.com/semaphoreui/semaphore/util.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cli"

    generate_completions_from_executable(bin/"semaphore", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
