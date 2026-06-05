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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d09e3c081898e3e6bd1d57bb587952050599890be86a75d77a59de0d0f682066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34e3391ee3c61536719a44a19a003dd2866b2a2dedd3bd113debc7fe83ef6343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9871e9282bb5d89598b20f2ee5d61ed0ef2d23297e2c9f4bc47ff86b92ea5d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b225db7ea1de4e10b8e24156b1c2756f2871ae87178d081cebfe00c298a437d8"
    sha256 cellar: :any,                 x86_64_linux:  "50d13ee1a079ea27879d49537074b445d52124a99744a101b115f0079d913cc0"
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
