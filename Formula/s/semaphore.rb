class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.33.tar.gz"
  sha256 "6ea30f6b1f84a91f25f7cfb73ab34d893330f4e1e0aabd4ef9f8b8afa9222f66"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3527219120d9a2a497a8874073a909980a6d300ffe920c1de63cb1b05495fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6941efff9eefde55dde9a28c90d5654bba29dc2dca382bb04c62e5fde215e1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6941efff9eefde55dde9a28c90d5654bba29dc2dca382bb04c62e5fde215e1e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72c6461334a904e6b6fba18691e15f28b96feb2afd9f97469972fb92c816ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd88be0a1af69e1202eab056dc2f6013b197f60ac87e7e60777c1895870ed31d"
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
