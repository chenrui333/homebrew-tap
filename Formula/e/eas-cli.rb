class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.16.0.tgz"
  sha256 "a3f0bf92a1fb6d595dd1606a4f518ab385c5da19388f12edece5c2a500b903f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b7bee59fe27bcccaeb22090ed622bc9abcaf7b20d3728cc9502a893099c9af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bdfb015f5144e0c25e85047311e0900aa2cb0328e455763d4b43fe1a7858ea9"
    sha256 cellar: :any_skip_relocation, ventura:       "b2bafba89f8bc1b08e70349622670358aa5dada1523ca7b7d06bd7a90245426f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27295d587879cf3b6a9ee2fdc2b1d85936f8dc694c620cc9c973aff750661c07"
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
