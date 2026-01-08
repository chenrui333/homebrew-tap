class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.49.tar.gz"
  sha256 "62c6254431a279c4351970c56267fc259db6bc12d4126d9fbccfb8e3d982331e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ee5d6a3b718d267abe8db0eda1910e62d60611e174a416fe13cadd46edb3c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f28fd383962edf6f4d06e11001863c083d5583b20be1379003c9beb13369c916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c34ecd3d5fce1d1ac94c6b2423e224d0069366d8bb2a0d89a8b9f050dfd2dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcc0852d20f73e01f46ebb0a4653596b43e4963516b4f383ee5162fe406b8268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a414d4a33a1d261f370b618f6805ecc300506ad768784f6b9f7f2fb95c6fc214"
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
