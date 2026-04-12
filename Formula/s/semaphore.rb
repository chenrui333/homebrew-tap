class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.36.tar.gz"
  sha256 "91d09974dac249dd3e2482c96c6a72702f8a6e2f726fcd7ec9d00f5a12bb85aa"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480abe9e006f6aef94d6e05d47fc003dd05dc9e23f913fad8a88b50c0be5ab74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfcf1cf695ce3f6293f3b17c9ca5ded52a62eb628ea74b9daeb103be499681d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eadb2b01f643a114c185eae7c584630d8c1129915b68f22954cfd87c00a6e5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f29fb092e9f6b7f07863e8af77ca246353603e588ac8978b295e604d8c4a4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3beab3c4a1300fadedb0a8a0dbd368a0f4eb4c34ce8f15860662b4ef822f2f21"
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
