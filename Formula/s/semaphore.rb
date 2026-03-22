class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.28.tar.gz"
  sha256 "2da454f39c48dcd1c182b20909c2138c3b16d22aa5d407bf73134a14af3242f1"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e1e7661d0257639bcf73d53df28987afba72d4d8969de8ff48a919e1ad48562"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecfa73d6fd8ff072d9ac5200500f76eb3da3f3ebd4589a70eda01b677f1df14d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd8ec5b89a854bfcb7156a714d508e3838d1d6820c55927a61571a474ccb51b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e981a5cc06684cc6245ca66bf75d99ffefdaafdcab20d696fb5603fa72aef187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c193c5c86fb8778f931d88ff857bd9c7fc0e7e8115e551cc428305e6742c4ea7"
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
