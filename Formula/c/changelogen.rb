class Changelogen < Formula
  desc "Generate Beautiful Changelogs using Conventional Commits"
  homepage "https://github.com/unjs/changelogen"
  url "https://registry.npmjs.org/changelogen/-/changelogen-0.6.2.tgz"
  sha256 "cd5e783f11a9496293d2c7790e36574981296192849a9d904dec617e65e257b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e613be74a1602faba8d9f859753ef7b24ed7d519ea21128591144ec1999828a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2149300f6b9fc22b7a83bf63de62f7f4b0ac59590e0a83586a1e3295bc306ef"
    sha256 cellar: :any_skip_relocation, ventura:       "fd43a71f6278c3ec5aa8f8981b326c8771e834e1a2e88ef8f4883252a7040cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab500fc7cb7969224190cfbde368e5d0523306e168175155f7f78b75a893b17"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "git", "init"
    touch "test"
    system "git", "add", "test"
    system "git", "commit", "-m", "feat: initial commit"
    assert_match "Generating changelog", shell_output("#{bin}/changelogen 2>&1")
  end
end
