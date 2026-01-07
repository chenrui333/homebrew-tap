class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.48.tar.gz"
  sha256 "bcda2542a59164b9bc28b9acbe74d1710dac34ed1ea919733048e99bfc09d237"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "667d2d9abcaac9aa6ad38fec0e96086984ad9b42dd7a901d8d89551eeeb6f1bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5781e5cadf6fb1774f6976493b482c8c802c2580d2f710a875b3c9604a9a289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5781e5cadf6fb1774f6976493b482c8c802c2580d2f710a875b3c9604a9a289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb81888daf7ad66b3416d882dc1414c496c41074f0d190371583bd322c01761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea450f55ae10b491d57f1c54014fa7d5e0846acf95cc585482dcfea3e3d5c82c"
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
