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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e603d7dac36ea3ee4128c85d624acb8749771fff71f4a074073716e37bac65b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75981bf84f5fe7cf09334622c281747236c2ea9baff0dd1dae0d6ef9ab26607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "370153c4e36266b87d9387e33cb7d1417c114bc9fa19645ca80d04e151c4b2c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f077d5a46a3e6b13d223f5f154a63c54f3b7fb948a0607283d2c7283a1d1d35"
    sha256 cellar: :any,                 x86_64_linux:  "a23b88b298e80ad1e6a5cbb16bf1ce3c3a84757b9cf97067b5712604d7f6e42c"
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
