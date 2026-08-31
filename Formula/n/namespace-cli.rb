class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.561",
      revision: "4c3442724f861077e51c3bb14d102b1ab349b72e"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25fb387d3ad74f1d983185b0749627d95b3a2524da1c6d7efa1d99c2bb6c28c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25fb387d3ad74f1d983185b0749627d95b3a2524da1c6d7efa1d99c2bb6c28c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25fb387d3ad74f1d983185b0749627d95b3a2524da1c6d7efa1d99c2bb6c28c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f937966636836cd44c88d276b7c131694dc7fa12b041ea4425b8b801753212"
    sha256 cellar: :any,                 x86_64_linux:  "ee2aa992f6b28468d1b321f7bfa740281a35dcc5c3272acf3c080831ad4fd758"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
