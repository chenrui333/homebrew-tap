class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.9.tar.gz"
  sha256 "b0d02ddc6950ee444f06bb9384ff9ffc0c72ca340abe0f9ba37bf24ce823841e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e208ec702258496fd6fefb9c76648001d9c2a3154e3f8d013c9945b2147cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e208ec702258496fd6fefb9c76648001d9c2a3154e3f8d013c9945b2147cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e208ec702258496fd6fefb9c76648001d9c2a3154e3f8d013c9945b2147cc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acf65747ea507deccd5e2e2af3a95df31af930add093183226a0dcd3b2bb280b"
    sha256 cellar: :any,                 x86_64_linux:  "ca4a18c552a78538e1b435162710e826f2c085c9671695675ae0003abaaaef1a"
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
