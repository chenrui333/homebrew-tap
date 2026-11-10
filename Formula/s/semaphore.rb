class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.20.23.tar.gz"
  sha256 "3712dcece48bf9a7708850d062299849357a9deb1f7e057020aa7610d2fa3e13"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f32a36cc01136b4532fd307946703aad1b4e6c0303f569dc17b3d7a733293f11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6199574548eb6b01037db42d5f11455e6d802265db8f00368d0b9e3373dcafd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13ad67ae3fb315b0da3afcfbc85cf823c1b1bd51e507f0a1c62802fcf0c7112"
    sha256 cellar: :any,                 x86_64_linux:  "a040a86e31999167431fde4d131facaf258bb57ce835c56e2146b6c2405af0f9"
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
