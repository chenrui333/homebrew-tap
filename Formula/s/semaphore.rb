class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.24.tar.gz"
  sha256 "6f6f16a03a3910d6760fe507cb19df42f1e1fbb9a29c21c8e6fa4567734d7faf"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f28e38bacaa1cc6371191a14b29bf57c5d62a991d179338f2fa69a764bd70a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e1c74395bcbdcdb812f0fd1259d0d80a4d3acbc4ffa1bf57a96e5702126f2de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef15ac13d67b2f949670bd4c8a3faad3554d28348f91ec4e9431138caf33aa95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4daba874cc87e05a9ab072089ea8c41ce482d2620f0bc3e8b4dbc0639e25a57"
    sha256 cellar: :any,                 x86_64_linux:  "290274da79f8ffd831d786dec7b0dda7592962fb2b112a7f6f8ad216ae441eaa"
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
