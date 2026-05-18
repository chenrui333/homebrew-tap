class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.4.tar.gz"
  sha256 "c676a83781106b806cd6e900b14cccf3bcda92ea9d06bb85148e6a65933d3b05"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f81235e668f1e461d35cf6b6b25d18e20c29ecee8681c5a75cd82faa7f256932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81235e668f1e461d35cf6b6b25d18e20c29ecee8681c5a75cd82faa7f256932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81235e668f1e461d35cf6b6b25d18e20c29ecee8681c5a75cd82faa7f256932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae83d9862e2941949098a61e039071f0b1f5f54b5f42f2407e735f419abfed02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1ee59a4a3aa6e0a9040ca88a8e174492e9bf363044ca15a12f2bd00f590c69"
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
