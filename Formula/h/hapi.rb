class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.11.0.tgz"
  sha256 "1e913a69c4de6ad0c998a555643fa31060f95d7e91980a8072e05f3b4088f544"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b87ae62b6cb5c325b0941cf0b4cd608ab07167fb3935227aade0a684af061241"
    sha256                               arm64_sequoia: "b87ae62b6cb5c325b0941cf0b4cd608ab07167fb3935227aade0a684af061241"
    sha256                               arm64_sonoma:  "b87ae62b6cb5c325b0941cf0b4cd608ab07167fb3935227aade0a684af061241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51734941d4ab1cf8eeb0aab30e6bc54320da2d48489e38294311113e3b2ad2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa857a1d2a1d5b44f05146ce4778f49fd7c10817a335b977ab90992e66f00ac"
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
