class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.26.tar.gz"
  sha256 "9459d081b3349fe11d9e050880cb181f71afddb9085d32dd1048dffe5a62caab"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b43d648b1bf6c13a9a8a18e635a0004c685bc8124d2016007fcc79b084e3f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b43d648b1bf6c13a9a8a18e635a0004c685bc8124d2016007fcc79b084e3f94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b43d648b1bf6c13a9a8a18e635a0004c685bc8124d2016007fcc79b084e3f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526214c103153b789e870370f582ca21ad35613d4461ee5427256528cdfe5866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3918d4d882c69e188f85ba13cfc40bca9126565b323e432b7841172216cf2402"
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
