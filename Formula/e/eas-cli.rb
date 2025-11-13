class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.27.0.tgz"
  sha256 "546fe49e8b21437933150a7f6bd2071c0d9563758c04ff06b79c3200e3f0a86e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2d3994fa2cc56f31d75e2ec31bd503bb1bd4800dfd634e7e1bf5738684772c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e96f908b5fd38f670d393e7e595f64da768b5036314fe6c589866161e5377dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e7b9d06ed85f113c98420b4d9af6fe0f505aa4354f2127505561d6d7c3210f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076113cb272c19d898227692facbd9022c44b6389d83813d705ab558e9ff9bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d781caab5fac0375199bdee8f5ff3e57b5ec753759d8ac8fa16f646c0ff47957"
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
