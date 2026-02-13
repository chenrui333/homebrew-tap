class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.484",
      revision: "0a436898501e88aa2bd51d5134f13f8db80127ee"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f234caa35bdf182a569ae501f2bd884c8b4a58dff0582d4c5f2d122e26193a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f234caa35bdf182a569ae501f2bd884c8b4a58dff0582d4c5f2d122e26193a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f234caa35bdf182a569ae501f2bd884c8b4a58dff0582d4c5f2d122e26193a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca5bde16207618ec9f19e5a6fe4eabaa8705c59515b9e308f7df4c81391f2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d033896e6d0b5d77bed3f2e75950955a1d0745881c3b11e83712a2a7b87183"
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
