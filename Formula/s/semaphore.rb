class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.10.tar.gz"
  sha256 "742ebd8ac7bf7f95692b6edc836e93443d15582e3b31147e9beb2ae58149d0d5"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ddacc47fa374c772d2bce2b0bdb778fbdabb2df783dd666e3504d246bb5abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4ddacc47fa374c772d2bce2b0bdb778fbdabb2df783dd666e3504d246bb5abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ddacc47fa374c772d2bce2b0bdb778fbdabb2df783dd666e3504d246bb5abb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3269c9f5009b3a55be6b8f2a4edd61ac7f3851184d6093dc0628fb74bc5d69c7"
    sha256 cellar: :any,                 x86_64_linux:  "a43166021d54e4d51959aacdecb482caa8fc469eb4f8dd6fc4c2f7ec684c79f5"
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
