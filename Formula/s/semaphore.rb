class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.30.tar.gz"
  sha256 "37652ff0482ccfdf234c67ed5c8f225d840b1ff2f0d0422012fc1ac28ddc92ab"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a92fbed1fcc3255fc7dc6c4dddf81f32c7dfa4f43a0f0d47a621084dc59cfa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a92fbed1fcc3255fc7dc6c4dddf81f32c7dfa4f43a0f0d47a621084dc59cfa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a92fbed1fcc3255fc7dc6c4dddf81f32c7dfa4f43a0f0d47a621084dc59cfa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16b41fb9d9eb982c4055cde82b8575aabe76df64fc2cec5ea77c7f7dd79f45da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6215afef991c93bbfce1f291b4d2bfbdf5a55464648583edd42e4247b016ca68"
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
