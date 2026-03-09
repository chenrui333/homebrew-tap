class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.21.tar.gz"
  sha256 "d65296f48b38ea4003b84e4a97995cbfb08592278e941c5de057f97a23a6b130"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3648e8ceab85100f4f37f42c2221b14a66e7ee4b7f48894eb4e805541ae8458a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f297e42ea87596ba8b50fbd9e1a923a7897c07489bbdee0e151de14bd902879e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3648e8ceab85100f4f37f42c2221b14a66e7ee4b7f48894eb4e805541ae8458a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f94f46d44539f3da8cfec2a75cec7081dfb6aeaeba02456c6006a1982a3ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b379462a8fa0b76c28e5590a09683d84fa7a448408c1a0053ff06bf33e1e88"
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
