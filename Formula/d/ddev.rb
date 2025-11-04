class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.24.9.tar.gz"
  sha256 "a88130b99f59152c0e6ee24b99927a4371bf0d54b624aa8a2918eb25a80beccf"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6fd68a80610cafe8e69f16045ecaa6976f0d0c93ef11a0f319f99809c7ab30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6fd68a80610cafe8e69f16045ecaa6976f0d0c93ef11a0f319f99809c7ab30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6fd68a80610cafe8e69f16045ecaa6976f0d0c93ef11a0f319f99809c7ab30f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af7acb346ce18cac8e1dc8bafbc7c4d3015f208caa35daa89461491330d07b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70bcd8fcc331e7a6f2b9d4b39b1cd9a50a1c8ef1671baabbdb8718f69ac0865b"
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
