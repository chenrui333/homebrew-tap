class KubeRoleGen < Formula
  desc "Generate a Kubernetes role containing all resources available on a cluster"
  homepage "https://github.com/coopernetes/kube-role-gen"
  url "https://github.com/coopernetes/kube-role-gen/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "a1602a053e5f4d4424ea01295956ec8eaef53ce2b59c6eddee1d076631946b5d"
  license "Apache-2.0"
  head "https://github.com/coopernetes/kube-role-gen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da3d8576c8996c80c941767a860d4d1fde2d4528fb53442bd30d17daf3a37e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aca501644d5cf5911283aac8184bdcd3f26f2c5473835d81d2a252aec156bfb"
    sha256 cellar: :any_skip_relocation, ventura:       "c79d037d9fb77f1dba89ccdebdac81737610c44c0963434c5a5db971e44b32da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7437e852e9ff4ec2e91f3bee74a3ce36ecf0e3d9ba85129046c6e66f998207b5"
  end

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
