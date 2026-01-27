class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.13.0.tgz"
  sha256 "1338cd2acfc267138258036d6e1fc643ee787211fd560ca92357ec95e285dd78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "212f882d095fb17bb65f28a78cf7a9880e1cdb1557df852e0bb557f7757c349e"
    sha256                               arm64_sequoia: "212f882d095fb17bb65f28a78cf7a9880e1cdb1557df852e0bb557f7757c349e"
    sha256                               arm64_sonoma:  "212f882d095fb17bb65f28a78cf7a9880e1cdb1557df852e0bb557f7757c349e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "606e11b05a7d74fce085dadd0da7b52973772e4639699ea3317f22ba0e46a809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "644edf571e850057dbd9881bd56ee030ef8bffc5d95ff4722039e71cf9fcc978"
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
