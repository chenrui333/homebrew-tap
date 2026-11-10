class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.21.tar.gz"
  sha256 "094108d7bbf075e7df4f84c4521e531a5ecd4ed7e8c92ac2833833d21cd7272a"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed124f9f3d27177a34447c39355edeeb66d8c0e71a1362d769ca494748092c92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed124f9f3d27177a34447c39355edeeb66d8c0e71a1362d769ca494748092c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83b2af5bfcf7e4ab4f5a2397781756cbb596a1be494aad599bc090404b558396"
    sha256 cellar: :any,                 x86_64_linux:  "9af6bb163177957f919fd09c9766ffa9dc1a414d85b84d038e133d6b53f79f51"
  end

  depends_on "go" => :build
  depends_on "go-task" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "task", "deps:fe"
  end

  def install
    system "task", "build:fe"

    ldflags = %W[
      -s -w
      -X github.com/semaphoreui/semaphore/util.Ver=#{version}
      -X github.com/semaphoreui/semaphore/util.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cli"

    generate_completions_from_executable(bin/"semaphore", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"semaphore", "server", "--config", etc/"semaphore/config.json"]
    keep_alive true
  end

  def caveats
    <<~EOS
      Before starting the service, run `semaphore setup` and save the generated
      configuration to Homebrew's `etc/semaphore/config.json` path.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
