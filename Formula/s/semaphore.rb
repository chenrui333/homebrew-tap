class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.47.tar.gz"
  sha256 "10a69efbb4f6e692702105c20f102d843a0016cf0cb30a0d4174636a73d40eeb"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e08f7e2d3cd41d193e8119e0f0036df31b6a8773288051ef592a17c3949d533"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a047e81543f52e7449ec7339fddc6650cb3d896ff4e702124501ac232d2e5ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e7ec719f77ca4b6255eff8ddb56833d5d78c9b68140212bc1b6dff389a35a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6482b91b8215e9bbcc67c358276ebe577bd9468d01a7f6596d3e50fac2c3f310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038cd4703337bfb002ae87bcdae4785bf033e6245f604b8a76249045603aceb5"
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
