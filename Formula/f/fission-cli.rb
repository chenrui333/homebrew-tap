class FissionCli < Formula
  desc "Fast and Simple Serverless Functions for Kubernetes"
  homepage "https://fission.io/"
  url "https://github.com/fission/fission/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3b6efcd3146332e986fdad0fddc9d43ab2adc08c57cc06dad8d1b89f1a19d553"
  license "Apache-2.0"
  head "https://github.com/fission/fission.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a21ed803277daa111ce1f134865e6da487f2a88224e70b6e6050559b2c31e8bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21ed803277daa111ce1f134865e6da487f2a88224e70b6e6050559b2c31e8bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a21ed803277daa111ce1f134865e6da487f2a88224e70b6e6050559b2c31e8bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c89cf7195da1cec13dbab9ee4a4831dca680d630437697df51a0e5c523d039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a5f0ee88b8c9709119f7789404bfd33d163d24248a7dd04b2de38867e9a927"
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
