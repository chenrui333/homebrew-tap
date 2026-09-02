class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "aa5de78b4303ffbe7d11d522ebc143de7aa47b43c308383d14509cea602a13f6"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34f7fcb365d8b2128eb23e4b9a7cc9dcb5e282f2beed469cb98a24105bc54da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f7fcb365d8b2128eb23e4b9a7cc9dcb5e282f2beed469cb98a24105bc54da5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f7fcb365d8b2128eb23e4b9a7cc9dcb5e282f2beed469cb98a24105bc54da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f3cce38ed654b5fa4f4890f6225fe634bdfb2e2dbceb2ffcf385c8b6525f167"
    sha256 cellar: :any,                 x86_64_linux:  "3caf36c5110778db426d80ce7c3129ae34ef149fc767d4f59fbc34b69a50ec0c"
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
