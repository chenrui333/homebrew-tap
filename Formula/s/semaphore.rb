class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.18.tar.gz"
  sha256 "582f2c71efd398788b22562b13577aeed8a8bfe0b39a41b11c5da404fe221def"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5bb82d25df44a2447cf3cf0dcef8daa444258d20eef276397c83e5e0a34679d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5bb82d25df44a2447cf3cf0dcef8daa444258d20eef276397c83e5e0a34679d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d15841f36de8e2af915fe0cc51cd2dbd0395b7c6df8d49bb143f76ed70489361"
    sha256 cellar: :any,                 x86_64_linux:  "48c7f84eb8aeb9ef42b3e80cfb5b83e845cc30145023273b2a5163b9a60d2e0d"
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
