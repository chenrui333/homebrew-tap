class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.3.tar.gz"
  sha256 "042b590cae702fd4b21246545d78920cb40070fab884147a1a6ab0b9ad476e6d"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f42267f1ee999256e9a93b77d78c0f5cc5c32c0026045f0087f2955c89ed9a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f42267f1ee999256e9a93b77d78c0f5cc5c32c0026045f0087f2955c89ed9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f42267f1ee999256e9a93b77d78c0f5cc5c32c0026045f0087f2955c89ed9a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0e5397b581116b851283fdeaa3da7460ee264aec71494f3ea198e95a6871d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495fe4ae524799386b27d353f6fc3f90436c0bdc9773f0c6ae963290d9525116"
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
