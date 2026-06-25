class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.14.tgz"
  sha256 "be249e225047ea415dcae92882db3ae3a257213a49b58092a54e573cbae4d2ad"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ce39771847af3f952d368e0a27db27fa4cdd3701e0f9d8ad9aaf8e5b435c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ce39771847af3f952d368e0a27db27fa4cdd3701e0f9d8ad9aaf8e5b435c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ce39771847af3f952d368e0a27db27fa4cdd3701e0f9d8ad9aaf8e5b435c35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085ea23738347708989d0e932d04a95fcb11565816bda71d146c0c18fb943708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442573cc718a2cd175231e15baf4726bd90f0f9c381eea6715d274ed9eb5fff0"
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
