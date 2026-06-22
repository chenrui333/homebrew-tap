class FissionCli < Formula
  desc "Fast and Simple Serverless Functions for Kubernetes"
  homepage "https://fission.io/"
  url "https://github.com/fission/fission/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "3e9be3fdbf7b8db8fbcf629e12260b30005a0c022f33a0d19b660ea59fc7f6bf"
  license "Apache-2.0"
  head "https://github.com/fission/fission.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0caf7dd2b1b7dc680b55f85ca45dc4ff5b599edca3117a86c4aa210dd98afc52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c149bb9d5030fd9c95ee4f6968bc9aea7cc8cdf021db8f618aa40f1dd3980fa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda1c7480019322da2ab9e19a1a9cf5fc56718e12413d3a41fc9010264d18b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c217486f99876bded68cabd5047ef3d4668f807ea831583c99baf439ca8f219"
    sha256 cellar: :any,                 x86_64_linux:  "fb292979d205dc272a6df83275e2f55f7c648c4f6a42d368a5c8c5c98211b0bd"
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
