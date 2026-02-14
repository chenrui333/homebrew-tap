class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "cf3d22582dbce045b1622b2e21fb8d4550db435a5d25fb98701772fbf9e342d4"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90d6d04bbef4b894f238668df21d80dc5c173c0e52df2defc4d22199c03ff64f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f6f2ef6e8066c2c9d14a3e883608aa31f7e02ef3c2b8895524f1543d74707dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f6f2ef6e8066c2c9d14a3e883608aa31f7e02ef3c2b8895524f1543d74707dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e2ed8b12f1a488135cad4b472a93ba7cf7fcbcf72c47c296d29a4d14f06564f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d58bf496c85cc576363bc820b7d055368ff76b5e1af10abf3faf07d948ad966"
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
