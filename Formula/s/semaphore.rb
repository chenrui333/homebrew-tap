class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.14.tar.gz"
  sha256 "6b5b331440c52b40345037b0d6f36539630b32f866753054f420db681fc1042c"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf9f50b1978ec37913d08f6e784d94f5e1cd8bbd876f49ad69356d36b72c6392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf9f50b1978ec37913d08f6e784d94f5e1cd8bbd876f49ad69356d36b72c6392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ce0cd22377843b916a85f7fb1a1981145b538ee9bd86665201e79c28a76a331"
    sha256 cellar: :any,                 x86_64_linux:  "8baddbca5061db7338ee8d003feaf89893424e154bfc57b0085c611f33b57e26"
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
