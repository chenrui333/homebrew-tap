class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.13.tgz"
  sha256 "dc043f93db9beb3fa505d12d87428f7224155ff2758244ff90eac1ddfa323ffe"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6199fc109fa31fa9d6e924ffa1a3a6b11654912554e50875aa0035dbb848bf66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6199fc109fa31fa9d6e924ffa1a3a6b11654912554e50875aa0035dbb848bf66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6199fc109fa31fa9d6e924ffa1a3a6b11654912554e50875aa0035dbb848bf66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd93df031e6ba173621de1b9bec8e90906216bf23be1b50785a20aef2220383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b09d3c4027d7a2fa5fdc74c0f2739007d10f2541cc4f2e6305eec63f6be1ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")
    assert_match "newsjack", shell_output("#{bin}/newsjack --help")
  end
end
