class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.50.tar.gz"
  sha256 "96e9aed2e6fb5038efa83cb4e4c853c5f8aa19db50519deabd4548299ba560d0"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e0dd24b574ee28de8654ddb132665a8e88b3815cf930a0eb2e4db58a9eb8b3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbb3de4268f0bd1a921754f02c2c9e7540bed2535b47eb2e8bfd5ba8d520c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea990a0c28464b88ef670a8217070ac82c215fce3f95331e6599910f7ce8b027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5affa33b8d251e92610abd4905e607776888706533bb2643784a7a883b612615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb79f33e49bd5eecab182627a992a1e1886325c507ae492836ca74b8ef1240ed"
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
