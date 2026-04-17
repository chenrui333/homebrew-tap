class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.37.tar.gz"
  sha256 "8ebf4903417efb91da150fa66c82c114139e5fbdd46d5e897ff19f6f92086fa3"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7f9e9d49ecf4144947d374f8647c48031ecb6e4cd811570c5fff52ff9427e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f9e9d49ecf4144947d374f8647c48031ecb6e4cd811570c5fff52ff9427e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7f9e9d49ecf4144947d374f8647c48031ecb6e4cd811570c5fff52ff9427e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9efb722eaa45a922c4e7a2f6d48c8c6d6c0f96d5f9eca8e9f82cbc12218a0462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79807381a4920f7edaf8c9f3b45fc242265f5f9b35b91d76737dbb0cc4d10543"
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
