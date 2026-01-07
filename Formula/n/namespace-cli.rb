class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.464",
      revision: "bcbd60440dcf3bc661345da5ceaec417aeae54c6"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1c052be98a2eaa252db8ee39a5914d6ee25e1fa4c49bd6afc1955ea6867118b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1c052be98a2eaa252db8ee39a5914d6ee25e1fa4c49bd6afc1955ea6867118b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1c052be98a2eaa252db8ee39a5914d6ee25e1fa4c49bd6afc1955ea6867118b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe3c6eb80ebeb39b21c26e25de67cb931401016290d7ec782331d0a3a9cb4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14af081debfdaf0d8966cac5b832752cc260cb49bb1e85640ab200fcbc1f6ce"
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
