class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.16.tar.gz"
  sha256 "a74fb2974c3edcd4b1184ecbb94d10c5328a42e744c1230603ce40b136499c9d"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5635c149436ca1e6c556358501340a6c400a650454d82012475d0da412dd61a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5635c149436ca1e6c556358501340a6c400a650454d82012475d0da412dd61a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5635c149436ca1e6c556358501340a6c400a650454d82012475d0da412dd61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4eca82ceebdfeb127a0b1f2d38796550364080547aed03fcaeb7d8cfbc1d55"
    sha256 cellar: :any,                 x86_64_linux:  "ca337c8b029af08702d63f0433713133e0aa1248eb34edda08883bb428c695b1"
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
