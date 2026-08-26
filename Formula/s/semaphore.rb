class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.10.tar.gz"
  sha256 "7e187c354212e1e0fd14cc58c97f6eff96ac030c24cb996e29cd22d09683a80e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c24fa39fe91974d0ab16920a0c907b198cea50cf1774699e81faaf32ee51c522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c24fa39fe91974d0ab16920a0c907b198cea50cf1774699e81faaf32ee51c522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c24fa39fe91974d0ab16920a0c907b198cea50cf1774699e81faaf32ee51c522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5790853af63a6fd5faaaa64a5fff8da5a168a8bb4722e8d3450e88f951815bcd"
    sha256 cellar: :any,                 x86_64_linux:  "e959d6edaffd18b744c250441ebcd9b1aed08a37db0a7cb69b88fc00f93c3920"
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
