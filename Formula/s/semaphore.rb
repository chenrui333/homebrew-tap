class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.20.23.tar.gz"
  sha256 "3712dcece48bf9a7708850d062299849357a9deb1f7e057020aa7610d2fa3e13"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b9e8804b2939c83a4a31598d7be47c19e0655d959ce3ecc562a2b3d4f8f3a12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b9e8804b2939c83a4a31598d7be47c19e0655d959ce3ecc562a2b3d4f8f3a12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c90d434067a009e8203fc5888f8c830a6aeec0a589a0e758ef930952ff6bff"
    sha256 cellar: :any,                 x86_64_linux:  "b1307f62778dd483bf1bbbe9c91b66a4ef461dda18f60f34b6842f374a81f9d2"
  end

  depends_on "go" => :build
  depends_on "go-task" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "task", "deps:fe"
  end

  def install
    system "task", "build:fe"

    ldflags = %W[
      -s -w
      -X github.com/semaphoreui/semaphore/util.Ver=#{version}
      -X github.com/semaphoreui/semaphore/util.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cli"

    generate_completions_from_executable(bin/"semaphore", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"semaphore", "server", "--config", etc/"semaphore/config.json"]
    keep_alive true
  end

  def caveats
    <<~EOS
      Before starting the service, run `semaphore setup` and save the generated
      configuration to Homebrew's `etc/semaphore/config.json` path.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
