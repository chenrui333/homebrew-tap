class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.20.3.tgz"
  sha256 "b67165883bb7795481e40c75be80eb7cb8694310604af054f3efc6b635e9640c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c7dd522b763869bbcd160d72416e416721415771bd649198314c837e986ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a781cffa68e6f62c827516a999460658ed779cc56d455c81e2ad132773aea747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06cafaccb251074e3dd19553ac4529e547c1b6fc2e7c656a1c3848db4a968147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e344cd88f64eca55902bf4dbff58ecd7d56eb71a694d1c24f98f68bf55eb0a7"
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
