class FissionCli < Formula
  desc "Fast and Simple Serverless Functions for Kubernetes"
  homepage "https://fission.io/"
  url "https://github.com/fission/fission/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "5f9e4f846544fafc53a0e0b017813e10294a681167fcac0cff7541647ad25593"
  license "Apache-2.0"
  head "https://github.com/fission/fission.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84f088e768adf76224782117cfde03e1aeaa2ae13629cb68a02742f67c5bf791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7616751e7543742af6c521f9d18951afbcdaa5e2b9098352e7e2cd03263940b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d45c5c7bee4a3d22d6999c54e5a4501c25899477490abff6e6098e5b183c9d48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048f82ecd2822a29357babebb72cd66d8f7144361bb5407ce7e0b974d1e3f116"
    sha256 cellar: :any,                 x86_64_linux:  "228723c30651c62ab018ba2416ea0997d9c323637272646f8987c8f0f3046b81"
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
