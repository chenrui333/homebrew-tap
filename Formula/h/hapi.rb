class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.7.0.tgz"
  sha256 "ad5b2336b96a274b682016695b36d8f4c86d6ef6ed088b55a7bd75f4de5e41de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ab2d657c6b1731735aeb66f4b627b92ea5a3c622c67ba6eb4a5df440fc326a7d"
    sha256                               arm64_sequoia: "ab2d657c6b1731735aeb66f4b627b92ea5a3c622c67ba6eb4a5df440fc326a7d"
    sha256                               arm64_sonoma:  "ab2d657c6b1731735aeb66f4b627b92ea5a3c622c67ba6eb4a5df440fc326a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a22e242673fb4a68997f65c1dcb4a0b1353565af087bde7e9822ac203c46afa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e55b7d320fd06fec57b4420abeecf44fd928a2237ebff7c87579e6c482f916"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
