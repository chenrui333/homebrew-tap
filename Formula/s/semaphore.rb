class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.28.tar.gz"
  sha256 "2da454f39c48dcd1c182b20909c2138c3b16d22aa5d407bf73134a14af3242f1"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcf76f86d411dc7c0ba8a54cb54a1e220da8612976adf4284f74c3f40098c945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaba354912e666a7610ddabb8ee2f55d37ef282dea90a2cf6db1f7663e700b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1115a84c7b032cf78094f2d81839ba1ebe6742e5df800fe1daafead4727da275"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da05c3e695ecb1fe854be54cef2b51c7f3a255c7f7f7062e89a9d524a44815ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d32ed1539c684cc73f769c4b4dcc5379021fc4533ca850c1679f6838e1cc59"
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
