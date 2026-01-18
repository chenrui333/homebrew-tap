class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.9.2.tgz"
  sha256 "ae6df577f0b80fa391a0b842fe3b48615d9b05e38293cefe770015832842e42a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "2bb732bee2e5f6fe2b655d4045c43d1c692a6830b37f72be056a854daeecbf9d"
    sha256                               arm64_sequoia: "2bb732bee2e5f6fe2b655d4045c43d1c692a6830b37f72be056a854daeecbf9d"
    sha256                               arm64_sonoma:  "2bb732bee2e5f6fe2b655d4045c43d1c692a6830b37f72be056a854daeecbf9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4550e42f5fbd35aa7971686060d8398a31ab87ba7ab54e86964a1df3e493e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3074eed96611e9c2b81500317926ae261156c842ddd3b8fd6fb7c7b8a7aeb5"
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
