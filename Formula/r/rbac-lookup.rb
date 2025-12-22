class RbacLookup < Formula
  desc "Find roles and cluster roles for Kubernetes users, groups, and service accounts"
  homepage "https://github.com/FairwindsOps/rbac-lookup"
  url "https://github.com/FairwindsOps/rbac-lookup/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "fdabf6a6c5b2e57662ffb583c4e549ce556ea8474679b49dd7f64a79b2043d12"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/rbac-lookup.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22697b7d33bd8cd8fcc5abd7429e03f117698336e143003974d27813d39ca305"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22697b7d33bd8cd8fcc5abd7429e03f117698336e143003974d27813d39ca305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22697b7d33bd8cd8fcc5abd7429e03f117698336e143003974d27813d39ca305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b73e11b8a3bda51cf325708b7cefc76d5548b00f0fb4afdd9c543fa59783748b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6fdffce1c6219411666fc7c9f42ca4c358b8d9750fbe4733600ceeb459ab246"
  end

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
