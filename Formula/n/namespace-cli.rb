class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.547",
      revision: "6ba2831dc69eeba9dd1bc345573024d5216090a7"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d473c54f5746351884074dd09f6266ad7dd967c65167464144bd160ff9a823fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d473c54f5746351884074dd09f6266ad7dd967c65167464144bd160ff9a823fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d473c54f5746351884074dd09f6266ad7dd967c65167464144bd160ff9a823fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58c12f741499523ce1a08cf7c405bbb8ae3d8ce44eb10559bca10d714a71d706"
    sha256 cellar: :any,                 x86_64_linux:  "ab14ee229ecf292fd055d0604261bc6c6aa3f460fcbcb3a012a45daae13c474d"
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
