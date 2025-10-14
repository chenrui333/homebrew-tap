class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.23.0.tgz"
  sha256 "370b168454f63fc6beba0ef17fcabcee940fdfb60001a641dd772fe6ef5a5270"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47ff00640228313934e0fd03340f5c9fdeb465a146b4f2af4e1c34e786b9f3da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5adbd2144688bbeaea5dd4d5ad962359bb0ad198fc0a6476bb416e4a04001898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cddf033df45752bdaad8e23831236d9e69e1bf0a917af50c9ef6afc491647d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7300d87e1c7089936baee14d05fb6a8c90c51287a740414b0950ae8cc4e4e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d500d35879e839718d8b3a8dcf19b44814c80b921f072961bb068e822ee697"
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
