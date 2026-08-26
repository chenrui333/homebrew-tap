class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.11.tar.gz"
  sha256 "c45cd3b273e52ad870517844061a2765a578a00dd20bd7a0a5cb6cb9ad0d5f5c"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2771b6983c1cd9e0aafb027422ffb3d78dfecb6b6929d4a62c8f201ba98a6b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2771b6983c1cd9e0aafb027422ffb3d78dfecb6b6929d4a62c8f201ba98a6b87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2771b6983c1cd9e0aafb027422ffb3d78dfecb6b6929d4a62c8f201ba98a6b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "585e678c4c217631e09cc489a73237f9603172c095d2cb608fc85a8f747226c6"
    sha256 cellar: :any,                 x86_64_linux:  "97b3eff337ad2790339bfe4efbce797a15347669f6fe94da22d1e98390de07ce"
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
