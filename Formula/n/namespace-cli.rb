class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.506",
      revision: "cfe32fe15099490f7d3d2890beca26d8e702d978"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d59726a3c499d87869d969e2c30923fdabbd7a0064d2bb3a77b49142eedfb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57d59726a3c499d87869d969e2c30923fdabbd7a0064d2bb3a77b49142eedfb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d59726a3c499d87869d969e2c30923fdabbd7a0064d2bb3a77b49142eedfb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df161ecaf3126a73580ca97ffff8d33bb5cc803d724dc364ed627f1a552b3292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a87a566b0c55a7bdd2980a594b1a8e34f1df951a394919e4abac97d29fc607"
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
