class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.601",
      revision: "be8ccd230383897650cd12898b63198863debbd0"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7fd348292b51882f2fb829e47243965d29e8c32545715541c4a36327edc3a650"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d952a76a13247c1f9184b3cf212afec994fe4b38f328762e0fb4beb4dbf592f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d952a76a13247c1f9184b3cf212afec994fe4b38f328762e0fb4beb4dbf592f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2d9541a135466b6c8685df7bfe4dd2d71609092902b3fdcf69b946b15664e2"
    sha256 cellar: :any,                 x86_64_linux:  "587ad72ef8ba2e23e24e544e3933bb9fcfb6ebffaea447708c8ee2db13f73228"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
