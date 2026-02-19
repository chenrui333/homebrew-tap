class Embedder < Formula
  desc "Claude Code for Firmware"
  homepage "https://embedder.dev/"
  url "https://registry.npmjs.org/@embedder/embedder/-/embedder-1.0.7.tgz"
  sha256 "dd25b5bfd7935c418bf3f75ef9636686e1e7448f7559254fa6e06bfc9937fee8"
  # no license

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@embedder/embedder/node_modules"
    node_modules.glob("@serialport/bindings-cpp/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/embedder --version")
    assert_match "Installed extensions", shell_output("#{bin}/embedder --list-extensions")
  end
end
