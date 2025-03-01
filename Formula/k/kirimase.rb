class Kirimase < Formula
  desc "CLI for building full-stack Next.js apps"
  homepage "https://kirimase.dev/"
  url "https://registry.npmjs.org/kirimase/-/kirimase-0.0.62.tgz"
  sha256 "5d6d0e43b8bd07bcae71b279820491053b8a1445c5e6f8f66f5f0d158a67d16c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ff0f1b043eade56267131bb3a3a43fa9bf7e31afc5a3ac50b202a797213185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf66e0bdfc37e66a13cea733188bf6c8384e3911b5a7c16eb39092d4559b62b"
    sha256 cellar: :any_skip_relocation, ventura:       "640a00fff88a9206fb921e6d29a7bec79157be45feac66ada2fff09f3815a4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268dffecc7c85cef629d0d97cf0a4d474f0fe04e3cc5bbcedf0c9503238cc2bd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kirimase --version")

    output = shell_output("#{bin}/kirimase init test-app 2>&1")
    assert_match "[fatal] No Next.js project detected", output
  end
end
