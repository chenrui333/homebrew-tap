class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.5.tar.gz"
  sha256 "ee1996dba5c6d878c1f7a579c50cbc0c43ffd1fd5b47dfb436825ca1bd79c8b1"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15e76129f32f97054385b2f34b88c7992e02af3250ba65fb3ed547734539f24b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e76129f32f97054385b2f34b88c7992e02af3250ba65fb3ed547734539f24b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e76129f32f97054385b2f34b88c7992e02af3250ba65fb3ed547734539f24b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77647f427dd3d98067aa332b1d5673eaf9f029195d08bc0a26ab4d233c74ac45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680f7906399c06d0373b81a9b0a0620d6e35a7ddd6a99989c38c76f71c6d9085"
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
