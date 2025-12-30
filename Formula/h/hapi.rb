class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.3.1.tgz"
  sha256 "98e7b0af27c9c48c9f46c11e0dd7c09cda42866c6b70055b7fbcaa7c7238e7b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3203c70378448436be23c6aba3e502b7b62094d749e061f1e213d1fa735eded3"
    sha256                               arm64_sequoia: "3203c70378448436be23c6aba3e502b7b62094d749e061f1e213d1fa735eded3"
    sha256                               arm64_sonoma:  "3203c70378448436be23c6aba3e502b7b62094d749e061f1e213d1fa735eded3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c3354105ff92d56f876e416781c21e3f6b70c49b5838c82250b71aafa9c99c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4da3f49e9e7b5d02de20033e30ffc41d5b2dd84f5823cc207ecf7ba6485e686"
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
