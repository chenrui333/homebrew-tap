class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "8c006c90826b45a102914f0369430e111de0a66b25fcadeab218ea0b5bd26227"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6c4b61960de2a63e87e1ce74ebf9bbc810f3e51064d3891d9b29d799c5eba93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c4b61960de2a63e87e1ce74ebf9bbc810f3e51064d3891d9b29d799c5eba93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c4b61960de2a63e87e1ce74ebf9bbc810f3e51064d3891d9b29d799c5eba93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a20a815d18f87ee2f09216ac53f64190c568acc4dbff31a4641e5a65366e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf3f84b7e76a1c71f569be94a0f9b17672fd8da7c0fb39f40d5e56d7da84d7c"
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
