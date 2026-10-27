class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "e3814c132f8cd53cf32957242bd3bf6bba1199b65d8e16bc9d43d11d6013ec92"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "340d4ee24c2fcb84bb55178626b7b96f659e28bd89ffee95c0f16c9514ab5062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "340d4ee24c2fcb84bb55178626b7b96f659e28bd89ffee95c0f16c9514ab5062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f9800c7b6d262a6fe2e4844df1301650f448e05d460b767ed8933f895f8caa"
    sha256 cellar: :any,                 x86_64_linux:  "1378febf29cea544f64768affabd15aefe42d60785ca00a47fb00a9f8643c2d7"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    assert_match "failed to connect to the docker API", shell_output("#{bin}/ddev start 2>&1", 1)
  end
end
