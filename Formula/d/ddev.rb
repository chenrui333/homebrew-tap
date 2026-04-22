class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "70e197045911c30a187b5966eebc9e48664f883a6ea20022b284f200cdab77fa"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf076a11e9881b072dd35aaf1b0bdfeada2e343f2c8cf659aa0b6ef0e1c16a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf076a11e9881b072dd35aaf1b0bdfeada2e343f2c8cf659aa0b6ef0e1c16a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf076a11e9881b072dd35aaf1b0bdfeada2e343f2c8cf659aa0b6ef0e1c16a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b020ad3e65480594c17cc2ac00b33cceed921686112b2ed12519c4d36faefd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a3469c5f3f430a78acb4acb597d1bdb06c9fa11db2438554e0dcb69477d155e"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = "-s -w -X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    assert_match "failed to connect to the docker API", shell_output("#{bin}/ddev list 2>&1", 1)
  end
end
