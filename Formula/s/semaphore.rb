class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.19.9.tar.gz"
  sha256 "9c434950a888309956bb62d2c8636f044da7347629f1c7ccc8122d92eaa05cb6"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b60bc41ae22047e3adc8d0ba66f97dcbfbd63e005bb8240618b25fbf183221a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60bc41ae22047e3adc8d0ba66f97dcbfbd63e005bb8240618b25fbf183221a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60bc41ae22047e3adc8d0ba66f97dcbfbd63e005bb8240618b25fbf183221a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63cf0d719eeaa04130df04677fd6740b3b0642d73d974d3eeff238beb9e2c602"
    sha256 cellar: :any,                 x86_64_linux:  "12e0c1081e9b4c3b0aa81dcd89e109fc3544073ddbace82b338e4c9b259e89e1"
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
