class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.14.tar.gz"
  sha256 "e6f5bcffee932a47cb82723c85113fc9b00c2f147b9ab555bd6988e473b9bd6e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00cef120512dfac13b0afeadfca2244c0e1a61fbb7cdb2fda8f3718d8644f560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00cef120512dfac13b0afeadfca2244c0e1a61fbb7cdb2fda8f3718d8644f560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00cef120512dfac13b0afeadfca2244c0e1a61fbb7cdb2fda8f3718d8644f560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd2d049fe6956ae9dcd3fc025222c602299c9fd1abfda000ce7385ee896fc150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dc6ca61cc586552e38021999d768990c7a1267b94c9d60c5b3571d5837776b9"
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
