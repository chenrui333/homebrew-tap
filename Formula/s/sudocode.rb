class Sudocode < Formula
  desc "Git-native spec and issue management for AI-assisted development"
  homepage "https://github.com/sudocode-ai/sudocode"
  url "https://registry.npmjs.org/sudocode/-/sudocode-1.2.0.tgz"
  sha256 "aa850176a5e51fb92de52a97048bf4526f23d1760595951c20179ad341faee8b"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Align CLI sub-package version with meta-package version
    cli_pkg = libexec/"lib/node_modules/sudocode/node_modules/@sudocode-ai/cli/package.json"
    inreplace cli_pkg, /"version": ".*?"/, "\"version\": \"#{version}\""

    # Remove prebuilds for non-native architectures
    nm = libexec/"lib/node_modules/sudocode/node_modules"
    if Hardware::CPU.arm?
      nm.glob("**/prebuilds/darwin-x64").each(&:rmtree)
      nm.glob("**/ripgrep/x64-darwin").each(&:rmtree)
    else
      nm.glob("**/prebuilds/darwin-arm64").each(&:rmtree)
      nm.glob("**/ripgrep/arm64-darwin").each(&:rmtree)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sudocode --version")
  end
end
