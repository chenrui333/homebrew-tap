class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.599",
      revision: "71db8318f0aaddbd4de47cfd93bad71438d2c1ca"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "eacaea31b312a55e35447f5ecf688fd19ed94d72f65b96406d5beb9186f4a6a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7808686dfcbd5730961282015654c99a9d6b99365701789bf632158be57ca3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7808686dfcbd5730961282015654c99a9d6b99365701789bf632158be57ca3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c4fc1579cf63cd58937625260fc2f4570174fc68d8233da2c9e7a03a8cd2121"
    sha256 cellar: :any,                 x86_64_linux:  "900d17e3e45e518a1593dff5d8f3ea874c73d0e49a807ee535f53e238cf75b15"
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
