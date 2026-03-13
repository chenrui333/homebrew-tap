class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.490",
      revision: "d8ae66ef11515a96a1f162260450a5de4e0a4a68"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2606e12c2a0661f4b78512466ad3f50167143eb82180bef959b7f31816369ff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2606e12c2a0661f4b78512466ad3f50167143eb82180bef959b7f31816369ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2606e12c2a0661f4b78512466ad3f50167143eb82180bef959b7f31816369ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c1377f0442ffe393ae3cafd60e13bc661f3e81c0637c793348a0faab4dc38ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e8fbbd2c631f7878d208f0bfcef52769afe6b4d4a5879e574c25fca60329e7c"
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
