class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.20.tar.gz"
  sha256 "e94de9738cab67950637715f5dd00015e559beafbba3bd226631b3431daef33f"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa83fcd5ef19b24a4d9d1cdedea9e97aa71dda91145e383d158fdcd058cd0346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d5d620766f7d87bc6a9b6f57949b15190fda066c11a1daa2d3b8491ac155c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b722426fa5da494341cc40801e8afda48704b8fdd143b4bf0d3111ba5e399e1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42c5c6b9012f4571f1f9d1343b282080e6b7e93a54f983f186a969d4be416900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef38dd1a844129d90ee69e312e1ee8dfaccbc49d06be6e5234bfe85701bca4e"
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
