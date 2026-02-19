class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.10.tar.gz"
  sha256 "be57d7363873ae73086942da270f25296d3881c6c3cc9fb71210a51471a04234"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a7bb1b9ac67f6b70d4bcb2c97379f9af0dee78e10a3a83b775b682667c4b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a7bb1b9ac67f6b70d4bcb2c97379f9af0dee78e10a3a83b775b682667c4b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a7bb1b9ac67f6b70d4bcb2c97379f9af0dee78e10a3a83b775b682667c4b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9edbcc76f14733bdb4101403878553697699fadec7729bd0afd88e93cc25da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1bfc4542a715f432f037fca90694f770d3157431a2704c931af6d08f0c0c30"
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
