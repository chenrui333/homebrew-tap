class RbacLookup < Formula
  desc "Find roles and cluster roles for Kubernetes users, groups, and service accounts"
  homepage "https://github.com/FairwindsOps/rbac-lookup"
  url "https://github.com/FairwindsOps/rbac-lookup/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "fdabf6a6c5b2e57662ffb583c4e549ce556ea8474679b49dd7f64a79b2043d12"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/rbac-lookup.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb83e32b005e32c9138815d49a52ecd3a6ceb01ceaa937e66d904cce9c30262c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb83e32b005e32c9138815d49a52ecd3a6ceb01ceaa937e66d904cce9c30262c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8f6e67b80b83189cf4f67ee745c98e78afe936434ddfb4c5672d620be812748"
    sha256 cellar: :any,                 x86_64_linux:  "c4142463fda016f9fc7ca6f9f7e8012da10b71afac3a54de3616a635682cc11d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"rbac-lookup", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rbac-lookup version")

    output = shell_output("#{bin}/rbac-lookup 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
