class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.24.tar.gz"
  sha256 "a50ab6154e5562bdc674ad1a887908dca0a362855722a7f4bea41bf630d2489e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16c0caf53c416f632737cbf43ca5993643350cff62dca966b386b09c56fee9c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c0caf53c416f632737cbf43ca5993643350cff62dca966b386b09c56fee9c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b46331c6802d9241cecde545747fc33520a82445f982b1520a216164a1c9e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac68cd092cee7295536880e0d3686111d865ec7bc253f0392e760be52c518dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c275cb0b9d931d6fa4856659a28dad6c2d0b41a48cf3278c2c136dae5c2dce89"
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
