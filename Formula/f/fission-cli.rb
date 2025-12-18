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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc1e61ee6570aba30a156ef7f93ed8f25a0f9eb26d470edee982ebb46d9111e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc71463d3a483ee338d980e8d89b461a023503630bd48548cac57ef15148eda9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59faa4877346bc8fbf016db82387b7666ee53fea592996b10cb18203cd4159b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5446736f32ba373caa5127d2579a069d96ac4d05ae9dee98e8b80d7736c3b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e139bd2980d6769cef6c22bb6398d33af870f18583cd84b27ed7f139ac5b8bac"
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
