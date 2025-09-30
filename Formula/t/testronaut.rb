class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-1.1.2.tgz"
  sha256 "e48a10fb0548d0d42bcdf8142494dec937121d776d68674a33430a37c2e33ea9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aacbb8df5c4b9a60def9d79d1533dc2b52e7b0a1d2f042674c2b34e0e40fea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd9db59be678e27f33bbdd118e3248be2cf819f7025049ffe2f839e6edcb0458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b635924e17e0a0cf0aa50aa0e402938c58c446d47756b779e2703717db593374"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "No `missions` directory found", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
