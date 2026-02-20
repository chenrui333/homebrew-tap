class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.14.tar.gz"
  sha256 "e6f5bcffee932a47cb82723c85113fc9b00c2f147b9ab555bd6988e473b9bd6e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae6210d48f7e269a8cd473f9512d3f00a6e1ebe630b897a444c02d5d2248b5c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7d1fc5dd4014b2f617f3fdec82213af0e5b1e359aa96a267d958c42fb3a34b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e7be7c73972833732062dde2f0a8fc0c4c322a0a96ff968a7a944d3c204917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06124454a384f5ad30ebb7f7c91925f72201a6085b7d9cc43263fee2f3aede7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b1c155edfc4bd659989b0e2ea64795a960f83efcc2bb81b78f14193b7d01ab"
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
