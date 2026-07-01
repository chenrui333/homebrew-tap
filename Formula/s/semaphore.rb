class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.18.14.tar.gz"
  sha256 "ae5d7224603de9f97c007b4f7a71ce51982b942334d05d8d91fec66719850a9d"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e0d1eea39964c5275e48832842a8e43581edac415f10a3315159e91bdec2eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c4d59150dace2277bb85f4978bd4f6fa253b0601c18dc35f27f9e0b53e5f2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae415aaf7753c64f4ccd5ba6d22303e0e30bc9769ca8065a7ec107b1190d341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb6ecb5e49587c25e0a0b885f42851f63aebffe5286cb9fb6be8074cc0f48cc"
    sha256 cellar: :any,                 x86_64_linux:  "eeaa2534903c6499108f005f14dd09e77ba2b65f51878b234997776c8aeb5d27"
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
