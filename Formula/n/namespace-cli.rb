class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.491",
      revision: "c20983905ca23ed88704c62c260922c1b972d85e"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d0b189f0b59dc7f9c2c48dd625be640249ecfd7eb665b48f2e8c46f02240ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d0b189f0b59dc7f9c2c48dd625be640249ecfd7eb665b48f2e8c46f02240ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d0b189f0b59dc7f9c2c48dd625be640249ecfd7eb665b48f2e8c46f02240ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93e0ddacff461cc689a3338a8dbd2096ed5aefca4860f73eb2add88810b80d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355b48eb202ce0e8a867e9dd5a24ce9fe0ecacf444f92b4d3b57e5ce193c5e51"
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
