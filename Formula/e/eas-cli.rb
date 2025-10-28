class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.25.1.tgz"
  sha256 "7309e48c216d0f134f5aefcacc076a6317597916b5b3e18d395e6c6aca75bfee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500b5a2c9c397d0962484fa9887572ec4910bf27d5d2f8212aa491cc6f87e200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ed1b08d810513c6cbd55dde278d63702bbfdf86fd822ba9f722ba9dbcffac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd5b8db6311479c0cefb042370b23b4cc133d76a2d2dd3ba978c81716ee1a43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4323ef3b97f22615918cee4903246267682e61fc7684ca7e43d414f17572b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee69624c17c0629172bacbbc2530d57e47bc7a2779d3de26da4b0269dfddf2b"
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
