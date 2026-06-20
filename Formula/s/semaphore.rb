class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.12.tar.gz"
  sha256 "206a99d6f6b152d40ee856d3104dad4aedc78e9b52913faebf7ce28f73359986"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "859dd0a66c6dadbaefeed57b779bc162c82c4b92460556410cfea030891c02a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "859dd0a66c6dadbaefeed57b779bc162c82c4b92460556410cfea030891c02a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "859dd0a66c6dadbaefeed57b779bc162c82c4b92460556410cfea030891c02a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1297a41a25bbdafe9a656ad6b9b622ae286e234b076f163cd5b73478e04a388e"
    sha256 cellar: :any,                 x86_64_linux:  "e753b8c843db522cf04a8f3eb497a8001ede3a4f1c469e4a2e2d81bbd4c0ee39"
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
