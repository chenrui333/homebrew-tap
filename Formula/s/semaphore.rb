class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.20.tar.gz"
  sha256 "3b2ab3693e784192458b8913f977c8ff0c8948342d1130d15f614d437061a9bc"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d539c36d3eee5348d6bf37ce6921816e283dc841171c04f3796e2481c3b039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c783edebf36cd6077331b402b1e18f7b9c8244e36314d56c3564a0b4508a96b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26093ade656798ff87bf5e66ee332acbce43442b4b5bdc45d3eee65b2a73ed5a"
    sha256 cellar: :any,                 x86_64_linux:  "f6b1ec81307b69214b215f525f3a0e201e5f8ca7111b02d232f96a11e3232f57"
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
