class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "5b0070fc84fa54e4120a844e26b5de0f5d8a9c1672691588f1fa215f68ba1e5d"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5bb1489781ec03c45d956cde41a207462ad07a2be4c8b8ed489e998bdbe5ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ae0cad0e115277b0a345a75f6014f28f677b4a0a361bd6b9853a8ea7fdad68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1cf906de6664e7666625137e85a0bdc7a9d8fcf003256e2fe20d887105d779b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae02b6c16d31d2757c8545eebd801dfd3edb2140020de052bb66b91354b1fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25f8cc76dc873e61c3ca7abe548895577cf94d935ec7261294d192bbad83b75"
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
