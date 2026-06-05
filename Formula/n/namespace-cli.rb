class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.520",
      revision: "6fd2a08926d2f8578e6495a57154e57f7b78d6a3"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7ce0f7c673d7a2842a0cbc5c9e4553ad38678ce14c38cb8173ba55cbb53c722"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2c3e493a507aea8cd32f879e767e7cffa16d63f7eec0c4ab2273f2d6ac9298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0145ef44a9e45eecaa4d7b4d1c9ff21d39cb7ac72977930fb995820a957d31ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c20784f59d6f8ff7d1d8d2f9a8905c7ed5b2405fada9e17d1a321d84174b31"
    sha256 cellar: :any,                 x86_64_linux:  "598d8b69c7461c3ea3223f7eec62fa97d992195d793946e16f92cd8512174ef1"
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
