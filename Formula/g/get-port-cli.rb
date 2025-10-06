class GetPortCli < Formula
  desc "Get an available port"
  homepage "https://github.com/sindresorhus/get-port-cli"
  url "https://registry.npmjs.org/get-port-cli/-/get-port-cli-3.0.0.tgz"
  sha256 "42bda9c04261747640267510fdaaeffc6cd712a3c54d675e43dc932cc0a0222f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/get-port --version")

    system bin/"get-port", "--host=127.0.0.1"
  end
end
