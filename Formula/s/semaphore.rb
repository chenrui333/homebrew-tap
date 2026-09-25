class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.14.tar.gz"
  sha256 "6b5b331440c52b40345037b0d6f36539630b32f866753054f420db681fc1042c"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "584b1db5bd96c28725b0236829d49b0ae83b1d0fb095d756f6b7351d84520621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "584b1db5bd96c28725b0236829d49b0ae83b1d0fb095d756f6b7351d84520621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ccf075308b95843caabca7c1fbb03dede01b1e032525fd61694f5cb1daa0a10"
    sha256 cellar: :any,                 x86_64_linux:  "9a863013cb1ba8b289258acc5b80c04a0f7c9953acf6cbcc31d2dd0750a9f692"
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
