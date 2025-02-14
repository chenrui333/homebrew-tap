class KalumaCli < Formula
  desc "CLI to program devices and boards running Kaluma runtime"
  homepage "https://kalumajs.org/"
  url "https://registry.npmjs.org/@kaluma/cli/-/cli-1.4.0.tgz"
  sha256 "b5d144ced6b9d210c4e49256bb49deaba573cd8e3458fd03261553ab061c6f92"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/kaluma"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaluma --version")

    system bin/"kaluma", "ports"
  end
end
