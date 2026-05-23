class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.5.tar.gz"
  sha256 "ee1996dba5c6d878c1f7a579c50cbc0c43ffd1fd5b47dfb436825ca1bd79c8b1"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb4f9e6068adc15dba27d9df8bf640416b2bb58e377a1b341508e8e48c89e95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb4f9e6068adc15dba27d9df8bf640416b2bb58e377a1b341508e8e48c89e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfb4f9e6068adc15dba27d9df8bf640416b2bb58e377a1b341508e8e48c89e95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "727832283c581cbc5e96958c9986bfa01ddc94062d48e4608bbcdafc37ee8fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f96be7afdbe8cd69bd32a1dad7ec3379ed5c1f347ae1714912052b856c67a3"
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
