class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.16.38.tar.gz"
  sha256 "5a7ef06a3d6f9304d4250a2ce8abd186fa8dddebcc4ad0b130acf069248bea24"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364d4b385de01f69b140a1350acdc96e6395a860f0abf4da5dbe20b861908b49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c74fd7cece43db7c3285fb25487002a7dcbe137e910db4093789faa155e801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "931cf4f2143f3c2ea93fd440c56f0e44798e39d636a6df147a5b0f65dbad97b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d7aeba18a1f4f36a6df1da7d4c03018aed22a61870a25dfcbee37ce94d249b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "294c7e82aa42e0a9627615ed4cbb85c39c7f403ea154f14991fbd0fe90d7045d"
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
