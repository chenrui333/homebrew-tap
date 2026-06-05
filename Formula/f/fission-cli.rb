class FissionCli < Formula
  desc "Fast and Simple Serverless Functions for Kubernetes"
  homepage "https://fission.io/"
  url "https://github.com/fission/fission/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "f4245ac67c20ac6c9e732c3f020a2ebb40f09bd6fae249389b22e125a8a0c24c"
  license "Apache-2.0"
  head "https://github.com/fission/fission.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc474d8c65e21edd283c18cd599f58117ef46f61b65dd8fc16e2667927837c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d39c879badd7beae43484d2482759de535b001093ae4aa256028e90f9ae52bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca0993a3f0e73d3133a50746e06811738e0937d851c41f9fb20e8de9d855f43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93797b00a631cfbf516bd1a4c94e01e2c16d9a701516444afae139891c3b8848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ded5594d199325392683bbcb1739dfc06759aef341529ff5a660e139af656d"
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
