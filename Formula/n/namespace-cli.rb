class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.512",
      revision: "a0711b29967c56502db9ea775cfe7d773c6a1056"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3be995b0c4046d2a2c291adedf3e71711786ce8f4c1303267062ebe85c0c364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "417d06405ee4aae643721c2dd018287bc2ceb9ab6c719371a8ea88c52bd454bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ef3a6b3c703b514970093ed75c2eaa8b54dc2483f90d0b896687e21d1a376d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773134a090fdd83bdc1a849baf937ceea4d16d2d3f8d336469c848ad67ab46da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2e1612d2c280fcedf2326f7e013f7026f7cbdd4702a723bd0ac589cfc8818d"
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
