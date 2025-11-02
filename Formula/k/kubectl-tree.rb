class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "f51426ecc5b6da799af61e49ce651de58df1970d7f3d515f52df05a33540e7c3"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubectl-tree"
  end

  test do
    # no version command
    assert_match "Show sub-resources of the Kubernetes object", shell_output("kubectl tree --help")

    output = shell_output("kubectl tree deployment -A 2>&1", 1)
    assert_match "failed to fetch api groups from kubernetes", output
  end
end
