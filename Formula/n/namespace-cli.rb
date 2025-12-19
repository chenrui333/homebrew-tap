class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.456",
      revision: "4abe8dd414c4ef6186ee914cc96cb45209ac1b08"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93679bf21a27fa2e7fd903abe5903f0e02fd48df8af84de6ea4e004f2eadd07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93679bf21a27fa2e7fd903abe5903f0e02fd48df8af84de6ea4e004f2eadd07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93679bf21a27fa2e7fd903abe5903f0e02fd48df8af84de6ea4e004f2eadd07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a528d18f5f84ecaa29ceb03176782dfb4ce9a70a05561aa1b3f2559fde38dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "814a67fc3d85064fd7a9dddba6c4ae12bfd47a7fd1e9075d8e04662834eab323"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "failed to get authentication token", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
