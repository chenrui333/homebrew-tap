class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.471",
      revision: "d5711c506ba8681aab4937e3b77963b29b14b984"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e09e8c4eca9f0904f783a3b416f327e47466583ece282572ed886bfa7dede26c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e09e8c4eca9f0904f783a3b416f327e47466583ece282572ed886bfa7dede26c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09e8c4eca9f0904f783a3b416f327e47466583ece282572ed886bfa7dede26c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c7477f086bb605c1004f9354931e465e128ff17c1b9383d8b03d14d65404503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8dddbe0a6cc7f9c1b5e9f927fb028d61ef62042b66da3ca639804b850d90653"
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
