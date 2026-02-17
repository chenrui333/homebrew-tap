class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.7.tar.gz"
  sha256 "259a2e13e95061753062a2289f308d61384393dfaf23a07a441cbc2609d6d97b"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13d9b594343de7676af6b2537e278e1690d73b798c467ef8cb0aeae3ab02ce1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "832ab0a8da866ea97efc2ff122efab89edb033e4edb542c8dc1df4f9a8af8a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "832ab0a8da866ea97efc2ff122efab89edb033e4edb542c8dc1df4f9a8af8a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e38130e8dc49b51e1e5e6425c7d5eed560b7c267e4cf6fce4318e0bb7a0372aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920d5dd9e83073076b1d26dfc35abcd799254721ddea9193c03f224f0fce9242"
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
