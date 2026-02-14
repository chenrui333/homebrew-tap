class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "aa0427b3eca1259693ac10be36760b5d86b7d73e20b28d43b65712037b850f42"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04dcbe7ed65f8e2f790529b65b58e1ce4962c34b6305c764c40fd728655d8f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04dcbe7ed65f8e2f790529b65b58e1ce4962c34b6305c764c40fd728655d8f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04dcbe7ed65f8e2f790529b65b58e1ce4962c34b6305c764c40fd728655d8f58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf9e9ca72286e2e6cf74b0dbf7e92a11f6af0a3c8baedca345a3e1435da7cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd49874c8ea5dbaa9c3aefddd7f864cc9c5780bdd93ec80981c907f8968bd7f8"
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
