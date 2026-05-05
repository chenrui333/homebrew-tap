class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.507",
      revision: "b4e50877511550f7799a9f647e2fc39eed5d808c"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b62c52af586001d27384ceea3649dd9841ffe7ba9bc2f6265efebc37c97e948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9abc0d458dae4d677b755b31e692e092d1dae0f2b3c4944b382b29e4c3e49fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b1a5cab119d130df48724001073ae76618d5a5fd94c90d419443e5ddd6bc49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c7672e08b613e33f45c47e1a959c25423a71977fb4461e89e88c9b9cd12e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a911ee1295435abe5c46eb597a4b6c9c31e9a653abb7d144bb8d45b1f22ed96"
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
