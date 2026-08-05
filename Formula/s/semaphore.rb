class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.7.tar.gz"
  sha256 "5b41e36cb68be4872b18ae3082532cd668bbc7db245239352082130e66e4cfd4"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "935ba5bcb8a7dc4faf6a56e8384bc15ab93ed6e8483e098e9e9ce7d13f1d268c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935ba5bcb8a7dc4faf6a56e8384bc15ab93ed6e8483e098e9e9ce7d13f1d268c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935ba5bcb8a7dc4faf6a56e8384bc15ab93ed6e8483e098e9e9ce7d13f1d268c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeba7f21585428045b74430be5d01f2bb39ab15a0138fc143319b6ab726c3102"
    sha256 cellar: :any,                 x86_64_linux:  "cb5b7b509f39a70261880bf759c74c9e25669513b24f328e965f5e24644ce5e8"
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
