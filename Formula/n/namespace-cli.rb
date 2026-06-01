class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.517",
      revision: "a25dce33fb38c74a5de974b2c71d48a6ebc7607d"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eaa37e18b16704f9c683fabc65567f13bc9062bad55fecd6e479a57a1f69d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b18fd41d8e7503b6501c6720fcb149d9319fc8b9884e7130c6bb52aa794e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f57c89d82c75e0dc316b9d816a1a5cde85fea4ea615627f0ba110cc7e1a7f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5677219d094e2c81a3907e92743a7551b9636d73a6747460bccaba8aa1a2139"
    sha256 cellar: :any,                 x86_64_linux:  "14d9f673c4d3a513021e89b15076c8b5c1e7185de711c275dd3cc4b9d494318a"
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
