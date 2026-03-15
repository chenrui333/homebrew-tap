class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.26.tar.gz"
  sha256 "9459d081b3349fe11d9e050880cb181f71afddb9085d32dd1048dffe5a62caab"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ba4d91495f351af197085e05a3f223d4017f1fd4f56daa98d507e2af23b0189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ba4d91495f351af197085e05a3f223d4017f1fd4f56daa98d507e2af23b0189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba4d91495f351af197085e05a3f223d4017f1fd4f56daa98d507e2af23b0189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd371845ae6d172b12f2ece3d906222106ab4de712bbda8b371a02f5e1c53bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1b352cdb6854e5fbc934ce56f876902004373cac8ad093e430112205d99942e"
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
