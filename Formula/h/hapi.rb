class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.9.2.tgz"
  sha256 "ae6df577f0b80fa391a0b842fe3b48615d9b05e38293cefe770015832842e42a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a4ec3df29634cf8ed4b918577a68b813a98a415c3829f450df52e05001d85562"
    sha256                               arm64_sequoia: "a4ec3df29634cf8ed4b918577a68b813a98a415c3829f450df52e05001d85562"
    sha256                               arm64_sonoma:  "a4ec3df29634cf8ed4b918577a68b813a98a415c3829f450df52e05001d85562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb019e613e14707bd4fcce2d66d278ad925a75e392a76f66a49664e8584c7501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3520b5c1709c42794d199b9b313edddfdbd2b7608f4ef6c58f85adb8594396"
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
