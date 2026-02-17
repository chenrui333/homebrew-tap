class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.7.tar.gz"
  sha256 "259a2e13e95061753062a2289f308d61384393dfaf23a07a441cbc2609d6d97b"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c535141ab3facab202e48e8587dd061c4c2e7523d255694ebaa969fbafb2b49a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8f910ba800659d2e7c14f8072d4a61d069b13b17ce0fb714641af07bfc1cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba0f218ddf1548335484cb1097bdd9fd0a1d12d6c36953a0ebac91c619c81e82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef17bd36e239bb4c358918670ea8ec15abe27ede51a29582a2b8b78acefdfe18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7c9eeab2e8bb2efe8ba2fe80e95ec7406bef243da5b78054126de2df65c789e"
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
