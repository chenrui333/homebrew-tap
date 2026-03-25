class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.31.tar.gz"
  sha256 "7a6844ae39f96acdb9fd62e6cf7410a7130128f075c038dd9a29bdca6dfe565f"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c97fa52aa1362c6ad8e5802ce98c5f4a73ab46a87a4c9a641941dd7358876d5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2fb42e47433e81c74ffd2b5adf6f1bee94a3b2d82e84726060849e3b5e066f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8717d5d332e668418ad821ee1c08b3fa35e0c8c159a28e47f329cc82192e702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "731b1cfb23d6877bbecc9bad061f7da1f65861d44bc48dd8835152afabbe1d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6befaca7577d5d22b26aab278f97e4ac6f0847be7f18e4fbf4e494ad7ad5ffc5"
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
