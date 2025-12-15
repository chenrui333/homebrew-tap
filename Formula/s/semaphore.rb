class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.46.tar.gz"
  sha256 "ccdc15e1a870c61ec9ed5220e8af63558679c1d7201515eecd466fa12326000a"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba5087dd38b719def93a58318ed80e4e2595bc1073e45d5a77db4c14cfdcba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ba5087dd38b719def93a58318ed80e4e2595bc1073e45d5a77db4c14cfdcba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba5087dd38b719def93a58318ed80e4e2595bc1073e45d5a77db4c14cfdcba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae178ce8474ed4342b12c1db88541ee6ddce8f0bcba08f5b3cd715d0b5c5d900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839ec10c4060bc7a5f2886546213111a81020ea0014d6810795a85e241809e68"
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

    generate_completions_from_executable(bin/"semaphore", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
