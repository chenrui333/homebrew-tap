class KubeRoleGen < Formula
  desc "Generate a Kubernetes role containing all resources available on a cluster"
  homepage "https://github.com/coopernetes/kube-role-gen"
  url "https://github.com/coopernetes/kube-role-gen/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "a1602a053e5f4d4424ea01295956ec8eaef53ce2b59c6eddee1d076631946b5d"
  license "Apache-2.0"
  head "https://github.com/coopernetes/kube-role-gen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e611065174260994e41ad90b00e6a0893c778c4e3d01731d3d8fd84b6c726b17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e611065174260994e41ad90b00e6a0893c778c4e3d01731d3d8fd84b6c726b17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da35ac55bd2c9cd7fa0f2fd2167c73df30c65cb6db7e807c5bebc3f6761e44c"
    sha256 cellar: :any,                 x86_64_linux:  "d05f35ebe961bbe7d40585c663109d00c259db4bea8f7c46272664b70b63ab78"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
