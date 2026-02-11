class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.480",
      revision: "adbcd125940a2d1da2051f8243f1baf147a9f810"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e91ac75bb0a9cb5d0bf60619d8d95720cb0b1921cd0ef8238c3fa4083acefed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e91ac75bb0a9cb5d0bf60619d8d95720cb0b1921cd0ef8238c3fa4083acefed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e91ac75bb0a9cb5d0bf60619d8d95720cb0b1921cd0ef8238c3fa4083acefed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8959b0d066ef2fa146351af864a7c343749fa91d12aa0718441433104cd74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6de53452c8db331691f12bc2826810911a321b78dec8af3c124dd300cbba1d"
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
