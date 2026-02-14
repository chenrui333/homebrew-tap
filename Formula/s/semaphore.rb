class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "cf3d22582dbce045b1622b2e21fb8d4550db435a5d25fb98701772fbf9e342d4"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445fd39a261c2841e649236ebe34cdd19106c6a41c6da4484fc82f83d7fd17ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445fd39a261c2841e649236ebe34cdd19106c6a41c6da4484fc82f83d7fd17ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445fd39a261c2841e649236ebe34cdd19106c6a41c6da4484fc82f83d7fd17ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66585d78bbe36bc224c0ba187103a89fd40ec493a0b5fc6888bff4220ce9a959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3114e3fa43a59cfd05e12aa02ca0d5e47609bd9545c75f7a9e36929dcb4a1c98"
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
