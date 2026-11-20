class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.6.tar.gz"
  sha256 "289015fbe4eb14e060f45116a91318cd36d1fe6c9aa6cba81d3228a403c22c05"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "093a6ab44f94eba07da5c110407f38a93ac759a19c530bcc7f29087f468716b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "093a6ab44f94eba07da5c110407f38a93ac759a19c530bcc7f29087f468716b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eb639ad3dfd5c20eee387c7ced003de140356727dd396673a5e7440520a81e4"
    sha256 cellar: :any,                 x86_64_linux:  "680a31ac6cba9957fd575a552c9b6ea7a927acd7c961c3a13e4b592d585bfc1e"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    assert_match "failed to connect to the docker API", shell_output("#{bin}/ddev start 2>&1", 1)
  end
end
