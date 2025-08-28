class Percollate < Formula
  desc "CLI to turn web pages into readable PDF, EPUB, HTML, or Markdown docs"
  homepage "https://github.com/danburzo/percollate"
  url "https://registry.npmjs.org/percollate/-/percollate-4.2.4.tgz"
  sha256 "8d726fec135df747f7b9e76dc069587de231b787c2dafb7a7665c89db4a866b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daeca915611aed03736272e469c085e40673f2a38f53280da8fc881bed94dfaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c47f497a464975794248b829e2497da6f73ad32142a069775e6256e3d7b4863"
    sha256 cellar: :any_skip_relocation, ventura:       "2f40fab462e024890696336d58b248a42be7844022b7f4c30e7aa5417be8c37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2eef1fa701ab259e864aac4d8ac8eab107a49d0d247d50248dc6c38083a94f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/percollate --version")

    # Since percollate requires Chromium, just do a error check in here
    output = shell_output("#{bin}/percollate pdf https://example.com -o my.pdf 2>&1", 1)
    assert_match "Could not find Chromium", output
  end
end
