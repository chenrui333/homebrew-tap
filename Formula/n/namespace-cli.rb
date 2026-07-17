class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.546",
      revision: "399efc812f6e76ed211a57e5227a92978a2c538b"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7120c630b9c7a837adba349f2de02343bf163b91c51fb5d7e0cdaa38b3770d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7120c630b9c7a837adba349f2de02343bf163b91c51fb5d7e0cdaa38b3770d69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7120c630b9c7a837adba349f2de02343bf163b91c51fb5d7e0cdaa38b3770d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03f06a978695feb53d011cee4fcc79de04333843aa9955a37565f4d465ff6009"
    sha256 cellar: :any,                 x86_64_linux:  "7aa0619491f6f9fbecab47d3d341dda338bf62eabc8cd2c2a3f23089adda5f79"
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
