class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.24.8.tar.gz"
  sha256 "73b5d155003e349c32c535bde075447a97201cb609e471636859a3b3806224ee"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7299cfca44cac9ffcd5c9f256c4e858fb3a57721a57e5341e905d31d0d2bf9f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7299cfca44cac9ffcd5c9f256c4e858fb3a57721a57e5341e905d31d0d2bf9f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7299cfca44cac9ffcd5c9f256c4e858fb3a57721a57e5341e905d31d0d2bf9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b12a577f957ac6f0dd1a043f8a026cdc5f2d8706f4ac34b337f88d311acf6a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a26b2ad3f5863792afc5523c267769b415882d2e04016ece632e0c050b063d"
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

    assert_match "Cannot connect to the Docker daemon", shell_output("#{bin}/ddev list 2>&1", 1)
  end
end
