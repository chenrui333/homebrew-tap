class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.35.tar.gz"
  sha256 "6bf3e2dc15301ca48cb6e3eed853a7f56e5dda577e8ff3305e256c49af7ba219"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0098e45ab84324290be531bff3b6e5994b1825b8f8d38c70c29eeeb968e5c88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0098e45ab84324290be531bff3b6e5994b1825b8f8d38c70c29eeeb968e5c88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0098e45ab84324290be531bff3b6e5994b1825b8f8d38c70c29eeeb968e5c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15ab903f9162167dc06054f485e99341266737361c277b718c05758a9e7eee5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a044c93ad5870fd1a011a4e8f3994036fe856182c3e99c6e2add209c15bee9"
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
