class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.43.tar.gz"
  sha256 "3c623b0a33cfe6ceb9bc5cc961980ea3586d73627b98e901c0faf6b9409378ff"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "948e95814ded6f048285312d1d9432de2bf97edd93013c7726da92e49298c6d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948e95814ded6f048285312d1d9432de2bf97edd93013c7726da92e49298c6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c6da36c6adec9e874c2fd9c9945a39c389955ba345000b2dcd17447387df31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a46d071f637a1209dd7fee1a9594a8c755f189a4fb2b5d87149f1a02cc063d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59388be22b7cb1557db668807bf3404b6d301b49a843e63ce9cb54e7c8e5a4fc"
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
