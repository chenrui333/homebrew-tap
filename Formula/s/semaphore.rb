class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.34.tar.gz"
  sha256 "7a28b7810394dacb65a49131a5332771aacfac77de06efa55e63e10c982a0e83"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5957ff0b0b0b768b22943c0ed11e72840c5821c0c8c9b8f2293d0974466cb03d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5957ff0b0b0b768b22943c0ed11e72840c5821c0c8c9b8f2293d0974466cb03d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5957ff0b0b0b768b22943c0ed11e72840c5821c0c8c9b8f2293d0974466cb03d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ff3b6101b672037c0f4827a48a4271b365b8f2a51964989a5b4a202cac9d9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209f35b5718e37056922e090e41a4b97ff03a6f6d97fd752773e0ae4ee136905"
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
