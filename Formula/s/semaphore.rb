class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.10.tar.gz"
  sha256 "be57d7363873ae73086942da270f25296d3881c6c3cc9fb71210a51471a04234"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7890af5d222af53fbf5b506e5f1fefde9c510d6b262cef76dfa7d7537a69ab0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7890af5d222af53fbf5b506e5f1fefde9c510d6b262cef76dfa7d7537a69ab0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7890af5d222af53fbf5b506e5f1fefde9c510d6b262cef76dfa7d7537a69ab0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32233c6e3b623ebdbf0450ca2c91d167071fb59c57f262dbeb2152cf6768101e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997eefa47030410ab99816bd7c53706b96313ec9d7b9e93f6338b032bfe789c7"
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
