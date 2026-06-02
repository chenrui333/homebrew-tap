class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.8.tar.gz"
  sha256 "a17c8693d23d3d68d21ad9203a60c20e5ca4408d9e3e5ca77564c05757fdebe9"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4422790c0045013689b7d7b84117bacd60983bbdff79f9943eb8b20d178d6967"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca3ef9b96696984dd406eff67b44e75948ea2083982e24e135d04c20f65b670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca3ef9b96696984dd406eff67b44e75948ea2083982e24e135d04c20f65b670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a28ac2b4cc22c01be54e37549e9f9ccf12adcd697bc2ae1d9c5c4edfb9b598"
    sha256 cellar: :any,                 x86_64_linux:  "f3ec81fde2c3ad58c2385e78518bf4d1b1b7a11f692445584aed6dd6583b22a0"
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
