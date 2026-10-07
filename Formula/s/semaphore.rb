class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.16.tar.gz"
  sha256 "718ab8143c5747de476bb2e7a1a20d0d0abbf478b122f9cbe15ebb9806c115a9"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4dd24dd23766c0a1b153773d808098a47a323fdc312c4c6034d5e0d59fca46a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4dd24dd23766c0a1b153773d808098a47a323fdc312c4c6034d5e0d59fca46a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a757b6140042a627857b68ab30e3442d1c1523d7875d947d61e7a0387813d9"
    sha256 cellar: :any,                 x86_64_linux:  "92261ca8061a693030ce49e6dbc278ecedc33ba102b11c9fd440ec60bbe4a211"
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
