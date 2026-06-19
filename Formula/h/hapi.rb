class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.20.2.tgz"
  sha256 "180c1867ef8730068e266054b3a172f89ab1d9cde67c31e9fccd59e68fdc285f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "04016e21ee5efa5065b5532404f8cb74d88c0810031dfe865c5de6ac81354b8c"
    sha256                               arm64_sequoia: "04016e21ee5efa5065b5532404f8cb74d88c0810031dfe865c5de6ac81354b8c"
    sha256                               arm64_sonoma:  "04016e21ee5efa5065b5532404f8cb74d88c0810031dfe865c5de6ac81354b8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac36152d28aa85aae1a05d8e54704af2b6f905ebe8af7d4a7334541683cb223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c98e9a2278b4780cd0efd4575d3b61796bfc8a262ea8e8101a68eb3bfab006"
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
