class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.17.tar.gz"
  sha256 "f7a3d62e066c951327d5cea1ee42f80663e06d112537586d54c08220e3c4eb3a"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a9b507dd034d87c5569aea62090c947ef9d910018d8dad95d6f9ed1e1b01048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48cac57099ac5593c27143686068dff3da4ad5ee40f679e58aeb0c264f8a7ad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9b507dd034d87c5569aea62090c947ef9d910018d8dad95d6f9ed1e1b01048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bdd5998480a5654135070425506f63c14b9ec0c24dacadcfea8dcfb0458afd"
    sha256 cellar: :any,                 x86_64_linux:  "20613cb9899e4d675df02157efa4a116d5ada139339dd400f6843f3ee966cb22"
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
