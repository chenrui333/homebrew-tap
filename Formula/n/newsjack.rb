class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.15.tgz"
  sha256 "309985d7b111ed8620d7494d2920bb242d922e8a0529bb9d73cdba2950733903"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7aff3ea43822fc41514e4af0f7b7248d1c89a140a70b8ab934aaf2cd79a5c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7aff3ea43822fc41514e4af0f7b7248d1c89a140a70b8ab934aaf2cd79a5c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7aff3ea43822fc41514e4af0f7b7248d1c89a140a70b8ab934aaf2cd79a5c02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "573080ac0f29516d6dab6e1d2a30f5d603d973217e3996e5229e1644e01fd0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0568b53fafbdb51d2e7f25ed8f01d372dd4402969bdf980810217a8477b2717c"
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
