class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.12.0.tgz"
  sha256 "efcb70a12caf59a8101edebd762ca3986d130a494d8e7709d999bcd65e0ff652"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31d55b65aa523527e246c07172ca264adca4c199e4832a75a51fa2c9b8254e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f92ba1a6dbddbbd9342cc1828950530e1a4d32a797d89617007a8f2a5a1b3a"
    sha256 cellar: :any_skip_relocation, ventura:       "75191610a5c9c42cfe74c566019bc82c6849f46c1c05d148877771383ad5ae1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f05c69a244da4799331ee98d6a577fc75308a0f982e2d00aa28264b72650abb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end
