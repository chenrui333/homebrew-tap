class KubeRoleGen < Formula
  desc "Generate a Kubernetes role containing all resources available on a cluster"
  homepage "https://github.com/coopernetes/kube-role-gen"
  url "https://github.com/coopernetes/kube-role-gen/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "a1602a053e5f4d4424ea01295956ec8eaef53ce2b59c6eddee1d076631946b5d"
  license "Apache-2.0"
  head "https://github.com/coopernetes/kube-role-gen.git", branch: "main"

  depends_on "go" => :build

  def install
    # patch version
    inreplace "cmd/kube-role-gen/main.go", "0.0.6", version.to_s

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kube-role-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-role-gen -version")

    output = shell_output("#{bin}/kube-role-gen --json 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
