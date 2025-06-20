class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.12.0.tgz"
  sha256 "efcb70a12caf59a8101edebd762ca3986d130a494d8e7709d999bcd65e0ff652"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f395509bdcd66bbcbb75a26a0595d746fa1c424e7c1fb3011a6208ec31cf17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83363b29c6b63eea1bbc57ed156f268df91a08a7a666db539c909e4241c791c"
    sha256 cellar: :any_skip_relocation, ventura:       "3270816b0e6d00ed99d2e2e8e5101a611d5c0db70fc94b92f7e6841b3e369e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abedc1bcef449ca5434dd647d5c2285b1491f3a5a1adbe7970c10aeba98986a"
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
