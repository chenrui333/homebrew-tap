class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "5b0070fc84fa54e4120a844e26b5de0f5d8a9c1672691588f1fa215f68ba1e5d"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "341d4f4411d60d4c4dd85dd11d59b683bf521a84130494ab5d9d1331fbb8b16f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c41c1f08f10bd8229da9b966a6ec78c4f7c591b0ad1ea4312379b75a0d37302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12b4e7321e5dae6b98fd00c4a82b9dc8cf57dfe45235dc186685d2f36eb2539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3470c4e4df62354cbd0bdd41d0a2a08cb73339a5d037c532bddfbc691a4bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c9943abcc27aecd25c91a158f0a22e99e56a799c8b830a93bc0a569e6f59c76"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubectl-tree"
  end

  test do
    assert_match "Show sub-resources of the Kubernetes object", shell_output("kubectl tree --help")

    output = shell_output("kubectl tree deployment -A 2>&1", 1)
    assert_match "couldn't get current server API group list", output
  end
end
