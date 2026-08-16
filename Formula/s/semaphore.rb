class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.8.tar.gz"
  sha256 "2a2b844d8f81364649dca7801e5a6de3b8bf9f1e5ce7b21d28e6ed1ce12edbeb"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49aab16520b5e35a7955e36173bc388dc27dfff279b53cd245c8888bc25e9f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49aab16520b5e35a7955e36173bc388dc27dfff279b53cd245c8888bc25e9f2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49aab16520b5e35a7955e36173bc388dc27dfff279b53cd245c8888bc25e9f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f599aa571e460dd7a2c29f2a67d28f310e59d798698020b624093782041259c8"
    sha256 cellar: :any,                 x86_64_linux:  "2390e9f1b79e18d4653c00102a0bcc3bd6dcb0d54d4ed3f1bdcbb86fe3971b8b"
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
