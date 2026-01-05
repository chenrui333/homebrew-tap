class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.460",
      revision: "570eeb893ddfd0280cb1fd531b1f999a74a91f1f"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba02ca0f2b22f4559e88647656bafaaac4180326c660bbdd2f93abc0ff2bd65f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba02ca0f2b22f4559e88647656bafaaac4180326c660bbdd2f93abc0ff2bd65f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba02ca0f2b22f4559e88647656bafaaac4180326c660bbdd2f93abc0ff2bd65f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cdeafa723cbcc05d0307792d7f2b0309aa153f1c7b6608132803d3da8c092cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61fa63f1b5f77b276f953f21ac0c5c4e82dfc9c09ff00c29df15dd88e2a9d3e"
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
