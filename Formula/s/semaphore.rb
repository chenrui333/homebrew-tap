class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.43.tar.gz"
  sha256 "3c623b0a33cfe6ceb9bc5cc961980ea3586d73627b98e901c0faf6b9409378ff"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3df0968edd8203193f0d31ac1736855ec5a1c3f1a1d75425b3ef288f9923bd84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa81f9afdaa49dbea46138b3784e940a93c6b71c3cea1f955e85153fcbb2a254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65275ebf03ae6036853eac88ecb6182a21ae6e0b2b8c9b19b8d0eae4362718d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4619c46db6cd92bac58cdb3046e82b60418d8c00789420c85e53c782ccc5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65ff0411d41f0c30435a3167d39650d8775889bd1c71e373694e58289976abd"
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
