class RbacLookup < Formula
  desc "Find roles and cluster roles for Kubernetes users, groups, and service accounts"
  homepage "https://github.com/FairwindsOps/rbac-lookup"
  url "https://github.com/FairwindsOps/rbac-lookup/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "fdabf6a6c5b2e57662ffb583c4e549ce556ea8474679b49dd7f64a79b2043d12"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/rbac-lookup.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be21a8b8b0a6745fbcf829a1d46797d8b073bd52759a406df764555c2e2153b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be21a8b8b0a6745fbcf829a1d46797d8b073bd52759a406df764555c2e2153b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be21a8b8b0a6745fbcf829a1d46797d8b073bd52759a406df764555c2e2153b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e1856614c0f46287436e3717771f46a51d2680b2a2ddd77cbb298cfa61fe18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90da988885e2b68fe5e19c9f7d60941221be27a09f674be37f41f436f7ed28bc"
  end

  depends_on "go" => :build

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
