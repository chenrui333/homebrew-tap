class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.49.tar.gz"
  sha256 "62c6254431a279c4351970c56267fc259db6bc12d4126d9fbccfb8e3d982331e"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a855c4ef06d073d6566dcca0de9c5743b9fed5e727205368b9a8593b33b892b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1548739ba36781f67bf3c51c818cde8699a28b3b4d2085b55da33149b7d58e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c66a75330673acf5931d39d9c640c2337157c3b6259c5ed05598bd55780599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222271768522fac875682f9b475022ac7c128338e6aadf21f755c3b748e5d1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e348b076ca6e4bff62fb5a558f0a429921f52e3cebacd643281793a22e0d69f"
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
