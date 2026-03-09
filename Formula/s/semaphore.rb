class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.20.tar.gz"
  sha256 "e94de9738cab67950637715f5dd00015e559beafbba3bd226631b3431daef33f"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e128d7ab2c32f4eaeb1f53208c7531dcbc824c1b389c9f6f8f4f959183d9db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e128d7ab2c32f4eaeb1f53208c7531dcbc824c1b389c9f6f8f4f959183d9db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2174ef25373be6e4bc02b8a847081980ff6f16df1eca96e9641e36ece0ead6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bbb99c1226ab325736957a2aebbda480ab4479ac936a17fdfafec95fe7fbedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5679ce5333757e63a83f189cfbf076cc558dedcbdb969c18746eb53ed8411787"
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
