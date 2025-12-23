class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.457",
      revision: "8dacc5d504bf9a2e8054dfe1c1be35087514a26b"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "002e146b33ab3256535d5b6c750519b39d1454e910aebb9be4bb6da05764e1d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "002e146b33ab3256535d5b6c750519b39d1454e910aebb9be4bb6da05764e1d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "002e146b33ab3256535d5b6c750519b39d1454e910aebb9be4bb6da05764e1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70acf6bb3ceabbfb8acb087b4f896b47fec94bc0d88f7613cc893e99f36e6739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184c5b0a4cd83cbe7a053a5078eba2d8a0a98ae34758a4e94a521c4fe8b97178"
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
