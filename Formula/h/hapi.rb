class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.25.2.tgz"
  sha256 "d5816d714f6aa8540ab3d83b1e156293b165b469e0a681eea1301949b3f29095"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6d755ea255e5db65625a6a884a27d72ff44ed5d70d8115fd262a48ccb4c94b12"
    sha256                               arm64_sequoia: "6d755ea255e5db65625a6a884a27d72ff44ed5d70d8115fd262a48ccb4c94b12"
    sha256                               arm64_sonoma:  "6d755ea255e5db65625a6a884a27d72ff44ed5d70d8115fd262a48ccb4c94b12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de7d5fba4214ab52fdcea0f129d692882153f704d68cd557833b2799f872755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e455719ee9a2d7684a3d180d17662441478710e2040e2c29841a83a9d9bc73"
  end

  depends_on "node"

  def install
    # Required for the platform-specific optional binary package on CI mirrors.
    ENV["npm_config_registry"] = "https://registry.npmjs.org"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
