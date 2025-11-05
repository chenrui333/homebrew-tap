class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.41.tar.gz"
  sha256 "be9c166ca2c5cf19feec80aa076e4eb0680154c446b583f882f8993e08b17bf6"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7f788b339ad62225662675a1ffe561e7022d1c27b7742bde4904b5ec9609c61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f788b339ad62225662675a1ffe561e7022d1c27b7742bde4904b5ec9609c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f788b339ad62225662675a1ffe561e7022d1c27b7742bde4904b5ec9609c61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4106279f761ec3c1a57c8cf03310f8ce3fe75fb0f02ec0496e70003aadb4cb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29749cb7289b20a9cd8550286d29bd6c7bf305b55de0c10188058cb49c9685d4"
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

    generate_completions_from_executable(bin/"semaphore", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
