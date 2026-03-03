class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.0.tgz"
  sha256 "018671f4db07ea3b4c5205f6d170f7fb6bec653aa36494078a478aaf0697f451"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b97c16d0f8aa1984ce61665b9d28a253dc28fa98d461740f3df315f1b590b109"
    sha256                               arm64_sequoia: "b97c16d0f8aa1984ce61665b9d28a253dc28fa98d461740f3df315f1b590b109"
    sha256                               arm64_sonoma:  "b97c16d0f8aa1984ce61665b9d28a253dc28fa98d461740f3df315f1b590b109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061a31a384021636084f925f8f40619c62ffe2b3b5c78a63581d89646c0fb820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2616cdbfa6394ba33489ca23985a1756e9c7d6c3c6906e695d95100fc491bd2"
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
