class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.531",
      revision: "390f704526845dacd4f884b62764bf134f2f210e"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "861bc16fa897e7065bbf2abfe36f107d8b238fbcb643d65d63416684d0f45e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861bc16fa897e7065bbf2abfe36f107d8b238fbcb643d65d63416684d0f45e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "861bc16fa897e7065bbf2abfe36f107d8b238fbcb643d65d63416684d0f45e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc8a3c4ba8ba30c19f7c93b4211ecfaa7219d53391cef997e14e0f6f5acbb96f"
    sha256 cellar: :any,                 x86_64_linux:  "5018283935af95f0816b69705b4e5969ca896e6eaec5c3f6febc702319434edf"
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
