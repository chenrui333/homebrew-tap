class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.28.tar.gz"
  sha256 "9f5a112fb818212e455fb62eda3be86975b16b8a18eeb8231c61ae3929d19a3c"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c74adf2d739c60d5cdb14d1d2c7f3fc7d080ce0e8468a47cbdadac18783ec05e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74adf2d739c60d5cdb14d1d2c7f3fc7d080ce0e8468a47cbdadac18783ec05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74adf2d739c60d5cdb14d1d2c7f3fc7d080ce0e8468a47cbdadac18783ec05e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2188962b9d055245b31a14fe394d22a01cfb6bb5b870c583a178490d8f643f"
    sha256 cellar: :any,                 x86_64_linux:  "bc33ff019984154ad3548dd179f40eee423201377e1adfe8d9e81e16d0d2d588"
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
