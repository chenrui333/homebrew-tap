class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.46.tar.gz"
  sha256 "ccdc15e1a870c61ec9ed5220e8af63558679c1d7201515eecd466fa12326000a"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d2a3c2387fee81666a0ba913d3a948406e92de51099cf52ad8c06d7424b5581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d2a3c2387fee81666a0ba913d3a948406e92de51099cf52ad8c06d7424b5581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d2a3c2387fee81666a0ba913d3a948406e92de51099cf52ad8c06d7424b5581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638ed40fea0add2d88886b4dad0a245f99786159ed21951994c60acabee11bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "419ad25f4d2e86d251c0850e9e76d8ae5d322e6bce88ba99a1c1babed9485bdf"
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
