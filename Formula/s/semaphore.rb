class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "a9486d492cbe23787823b873f16720968d3356ed10c38b66fd61f59b3f865fa9"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ba1634f9e9a75203cdb88c8d22f9c4684b201796a068f204cf973a56a7e2ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ba1634f9e9a75203cdb88c8d22f9c4684b201796a068f204cf973a56a7e2ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ba1634f9e9a75203cdb88c8d22f9c4684b201796a068f204cf973a56a7e2ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a86fa3d1c37de023bcae197a061877f555118c6ad151ae684d9bba043bec6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef63e586cc7dae2ee20a310c53ef996dbc7d915667382907574e3a3d866f82cd"
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
