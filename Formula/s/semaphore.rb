class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.37.tar.gz"
  sha256 "35985dd626f83713a8896180b973ac52e9a8e80ce8a2c55b04d8cf6f316b26c4"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5067f1100b459e234921335634626c8c43c21d18871d97c13ed07a265edc97e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5067f1100b459e234921335634626c8c43c21d18871d97c13ed07a265edc97e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55e459e394c872c2e8c95cf30feddd95b29d637d08c97b22393611b59b4560dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c455b67c1db965354aba11248b41fdc361e9e8c32d5c4ae3cfd8a9881a1a7b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff7f4c77eb912d809aae95d61be997299b9fab9fd7875f42d699fd2d264d48e"
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

    generate_completions_from_executable(bin/"semaphore", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
