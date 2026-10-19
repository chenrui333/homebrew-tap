class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.17.tar.gz"
  sha256 "ea97554e1278b09aedfb6da36bf8dcdc874b91ea6fe6752957f3f97bded5a352"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1df6911c6059696924c677bc33146831c7ee998543519595bdc9c41ea9cff90b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e244ddebfac78e1c4b34ac07f5f4c778d0ed672fcd53663571104f36f85c9951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b07d7161af4a7d1a5d5f15886e8f6cbcea4cb07f04c747f73eaaffc28b3076d"
    sha256 cellar: :any,                 x86_64_linux:  "de07e0111286c83eeda237d69eead2d6b211a24fc77246242af4e4bc4fae6a59"
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
