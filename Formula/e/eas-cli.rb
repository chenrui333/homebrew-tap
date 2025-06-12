class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.10.0.tgz"
  sha256 "a41df46e439d0650f18538edaf4a0ee6fa914e61a645907832f797a97f565c3d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be771ae5d7cab066404979bf0e618dc282f838381c7df944c67caffdb787c679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de43f9beefc1c640245d60a78669a72dc343840773b7660561b815a4e578660d"
    sha256 cellar: :any_skip_relocation, ventura:       "afd73f0971f3b2bb16c1b21b309373ad52a799ab97da2864962082c5edcdfa1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cd7bca264a0e500f5ad7218a1bd1926ff69fdcd2bf7f0c7d22519b7f5b9f77c"
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
