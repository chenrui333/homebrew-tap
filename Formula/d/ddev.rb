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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d842afdd3fc99e0a50418659e9ee8de28616da5607de8b571fecd11c653956b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa03b6603f5b675c1153f5868155da91a677fc151668e1e67fa4e3c47f7bfedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b488fdfed00e0528c43abb8169147aa9610b6fb7465e77c07771c606bf865c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d5ad14a9c3e12b58a3ad210a33e5b9614f8b5edcda00d0511d36fe0df854be"
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
