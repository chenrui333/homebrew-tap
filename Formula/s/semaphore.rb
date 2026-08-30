class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.12.tar.gz"
  sha256 "941263644479f20fdcd619790e5ba1241c5f6ed58b4a54bab6bde7fe3cda3a55"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a69cc5c4b85380dc3774d6fc9b34e691e43732d8f5d6b738fb9e8e280504419b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea5f119159076d9b5be56405ed6539b76ec86916b3e4881ac86a468398ab03e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a69cc5c4b85380dc3774d6fc9b34e691e43732d8f5d6b738fb9e8e280504419b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a95aafda5051b6293b77dbea3d6e62a706ec921c970b623b573768940e9eeb5"
    sha256 cellar: :any,                 x86_64_linux:  "48e01cb65eeda0863c4a551d742f5f24df4c02688bf22afb15a0af30af25d0e3"
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
