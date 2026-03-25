class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.29.tar.gz"
  sha256 "f00521eede503c0aa54bff1feb3948328bf762410f0a4391425b741770c4dd24"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f13fb3f3d6fea89f3987e3ffa184b83cd0b4b1a61b61f5cb966529c45352bb52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f13fb3f3d6fea89f3987e3ffa184b83cd0b4b1a61b61f5cb966529c45352bb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13fb3f3d6fea89f3987e3ffa184b83cd0b4b1a61b61f5cb966529c45352bb52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "218d42adb2b6dd5295f3a9b18dc9627e15ef39b8c8bc4c074443b14d0bf7348e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07b075a31ee9c0665a862299d0f9078eb2cd802e2dc46becc76de2dd18cb638"
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
