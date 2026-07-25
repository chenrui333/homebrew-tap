class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.28.tar.gz"
  sha256 "9f5a112fb818212e455fb62eda3be86975b16b8a18eeb8231c61ae3929d19a3c"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b31b9cc8d6b930c14958ecfb62134ab8acd2fb10212314d45b1de85c289c67a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b31b9cc8d6b930c14958ecfb62134ab8acd2fb10212314d45b1de85c289c67a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b31b9cc8d6b930c14958ecfb62134ab8acd2fb10212314d45b1de85c289c67a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac3aa371caf1144358d51b78bd8def4a4249cac364974f18459d46ea30c3d7b"
    sha256 cellar: :any,                 x86_64_linux:  "be8c0c0624d18558eae01d5a8429d56d1f8b1e7b4518e9c627aa29e4bc4af750"
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
