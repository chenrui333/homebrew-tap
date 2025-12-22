class RbacLookup < Formula
  desc "Find roles and cluster roles for Kubernetes users, groups, and service accounts"
  homepage "https://github.com/FairwindsOps/rbac-lookup"
  url "https://github.com/FairwindsOps/rbac-lookup/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "fdabf6a6c5b2e57662ffb583c4e549ce556ea8474679b49dd7f64a79b2043d12"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/rbac-lookup.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"rbac-lookup", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rbac-lookup version")

    output = shell_output("#{bin}/rbac-lookup 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
