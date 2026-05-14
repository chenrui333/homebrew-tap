class FissionCli < Formula
  desc "Fast and Simple Serverless Functions for Kubernetes"
  homepage "https://fission.io/"
  url "https://github.com/fission/fission/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "665b058b28294d897cbb14a27e3454535c3b5fb232088a2d6b8eae945796895b"
  license "Apache-2.0"
  head "https://github.com/fission/fission.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882efefb3da1ee41069b59957ea64386fba0e2650d079b4b6dbbcdd03736d262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d62e293d06d33e7a006191b3a4d7b0c7391b18459d784d7771e3411bc7d8ae2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032d7120ff9334daea2430329ba6fdd60be246ba711d2a22ceac187a388e0ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a5e1ff0c0ea6c9bf8cbaf735e7e0add9a1d6f8f3fb8041bff9f0b1dea1d7546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87855c8fd640d0abefcd1a77ce5b761186d4711175f0a8836a8caca72898271"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fission/fission/pkg/info.Version=#{version}
      -X github.com/fission/fission/pkg/info.GitCommit=#{tap.user}
      -X github.com/fission/fission/pkg/info.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"fission"), "./cmd/fission-cli"

    # Error: failed to get fission client: couldn't find kubeconfig file
    # generate_completions_from_executable(bin/"fission", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/fission version")
    assert_match "couldn't find kubeconfig file", shell_output("#{bin}/fission support dump 2>&1", 1)
  end
end
