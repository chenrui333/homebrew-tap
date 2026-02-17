class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.5.tar.gz"
  sha256 "39c0f17eda935d3969086fe4bd460bbcb0b33482d184e983e0346fa459455a42"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b22975fb0f1fd0d640c6d54b28786d2301ab8239cdd906bc15a31344f7c2a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b22975fb0f1fd0d640c6d54b28786d2301ab8239cdd906bc15a31344f7c2a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b22975fb0f1fd0d640c6d54b28786d2301ab8239cdd906bc15a31344f7c2a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "928a36eb203beb06aecbdf63fa82afc5f98838fcb6e11d382708c5a108c6a87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd6584035d18ef7ebb78f80834c7be6668145ce4d814e6b49c3482c428b61ed"
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
