class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.492",
      revision: "916b454299ba8a6c74aa0972defd7a8007b892d9"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5b60924dcb39c6e3825f8ec47b16d9b00b845811d957aa3ad19c3fb18702093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b60924dcb39c6e3825f8ec47b16d9b00b845811d957aa3ad19c3fb18702093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b60924dcb39c6e3825f8ec47b16d9b00b845811d957aa3ad19c3fb18702093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "942341ddd0cb84c4707f8895c716f3a079715dd85c26f0078002407d39bdbf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7a5f10bc16f6b79a3313eab637b66ff288adeae9dc0ba0246de18d6b3d305a"
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
