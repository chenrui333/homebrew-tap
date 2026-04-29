class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.39.tar.gz"
  sha256 "f1fa0bd6111bf0621cf0edbd2b54c264dc8cc77b756ef5e2ea8491276a9d3b5d"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe2455c22bd61557e19c22ae1b676b0b723534aca8d0646e65684e5f159ca278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe2455c22bd61557e19c22ae1b676b0b723534aca8d0646e65684e5f159ca278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe2455c22bd61557e19c22ae1b676b0b723534aca8d0646e65684e5f159ca278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6abd6464abfc0de14a445c699f9345a97456bfabe2fdd5465d153f0bc1d197c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0871d35f3e5740260a3f2c29480054c1718fe8d56db9be5895e5d547a8d42c5d"
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
