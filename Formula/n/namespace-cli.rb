class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.512",
      revision: "a0711b29967c56502db9ea775cfe7d773c6a1056"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e3e5c359ff012fc0aceddd7136c20e7f07d7a69204ea89876794b619d6850a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9b5eeeb9a0177e30d5148153f2e8215d4ed23b8d63683c416f9292ce6b1f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9043a175ddde17e8340f2d1ddf38e16fb4990af10d3945f4091f935b7c4bfc72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563f4df00dc7e3f73355878a0e8dba12cf438bfe663f103c84aa7962a2209ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c899acd14a952448e1cc5cb01af7e54f386f7edb2359f2a4dde53e004a405a51"
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
