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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7b23d8ccc8d0381e604de99f1a5a9552c87beb9c0e15c4252a146c6aeee68df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7b23d8ccc8d0381e604de99f1a5a9552c87beb9c0e15c4252a146c6aeee68df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7b23d8ccc8d0381e604de99f1a5a9552c87beb9c0e15c4252a146c6aeee68df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "872216cf183d9e0973dc8b3009b488119e495cd0bbbc836061edb616c76c4b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e34a4475bc776b874233d88e7d127c7dd0787e5574d50e5f860001b7d86c258"
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
