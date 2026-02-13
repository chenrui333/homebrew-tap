class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "204b22be2cb17aa4d4a65d8656032b5d1e73b2043bfb1eca94fcd651ebe91ee9"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92ca1c90e73dcf86a49e969c484a08157dfebe2008d3a5d312902710ce6235d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3fbbd1220ff9f56e87ed558a8a272fe738a23bfda9841ade7fd0f012c9f2576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "244087c4751c298b97084d391151266d9844138150fa198210279974d84fb785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c911929db694d8b5956bdc8aa0782ba8b52b1955de79f3a3b570770b1956780e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25368e20e6f0085fac2a8cfb4dcde56adcbe17de2b22e7a9566fd0c3834cd594"
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
