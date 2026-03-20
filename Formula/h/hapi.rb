class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.3.tgz"
  sha256 "d348b9d1cb9ba7f61eeb5c68b07a752ef755f6061263608b6fac37e6255837b1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "957c97e765ae56b4c769469281a1071f81a3290003d80366164d62b13e46cdec"
    sha256                               arm64_sequoia: "957c97e765ae56b4c769469281a1071f81a3290003d80366164d62b13e46cdec"
    sha256                               arm64_sonoma:  "957c97e765ae56b4c769469281a1071f81a3290003d80366164d62b13e46cdec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d4e77036854daec13c3c30030391df684ac6b4fc165b3bad0aa20528bf8f706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829584b034318fcd2d84362e3091ddd682b2fb12b7d4214026805dde4516584a"
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
