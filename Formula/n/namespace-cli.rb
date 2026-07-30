class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.551",
      revision: "2f4c728fd5f29c6f8d16420e5c31c32b2d981e70"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49e68980255cfc79ac9eeee942668285753c6c4c6cd694aa303df84004110f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49e68980255cfc79ac9eeee942668285753c6c4c6cd694aa303df84004110f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49e68980255cfc79ac9eeee942668285753c6c4c6cd694aa303df84004110f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a4011009a2db0172551d892da205f060c73812f2c221e0f264b8e1ad0559c7"
    sha256 cellar: :any,                 x86_64_linux:  "b22e0fe0856b120d7d0d1e9ad793abd5a2807acd5f944ad56a0b518b3a371ec7"
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
