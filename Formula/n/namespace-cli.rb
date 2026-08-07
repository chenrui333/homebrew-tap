class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.555",
      revision: "60dfb61d104138b4c293e5384021c8982040ef65"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37eb36407c56e32061de46f2a02acf51caf98560cbd94e0e599ff0b6400f8397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37eb36407c56e32061de46f2a02acf51caf98560cbd94e0e599ff0b6400f8397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37eb36407c56e32061de46f2a02acf51caf98560cbd94e0e599ff0b6400f8397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0661f03e0d847bb8b4d88622323ff1a636a08381cc2c5d1daa2aa8ccf4162ba1"
    sha256 cellar: :any,                 x86_64_linux:  "fd1746a6812ce322503ae48609700a67b384d479cba9897adf18fef444e3c76e"
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
