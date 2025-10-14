class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.23.0.tgz"
  sha256 "370b168454f63fc6beba0ef17fcabcee940fdfb60001a641dd772fe6ef5a5270"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e20d7db3e918fafc08da3ffd67e778e101f50c52622a700a08a4203356119a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e2ba8a1d234c9110256139a0b26db969d61d184f38fc64ff0766a6b738159ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef63a4583c8cba87dab1a5600c9ed8c63f3e040f7952df36f7598f4a6c7e3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d0a9e740b01639f953529eed1804ef30b3dbc0d42fadf9af192491b3d5ab18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f13e8f22e94d374731e60966476a384833453162d96fc560f41bbcef89b12b"
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
