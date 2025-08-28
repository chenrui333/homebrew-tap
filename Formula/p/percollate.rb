class Percollate < Formula
  desc "CLI to turn web pages into readable PDF, EPUB, HTML, or Markdown docs"
  homepage "https://github.com/danburzo/percollate"
  url "https://registry.npmjs.org/percollate/-/percollate-4.2.4.tgz"
  sha256 "8d726fec135df747f7b9e76dc069587de231b787c2dafb7a7665c89db4a866b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44424e7c2902661373ffb2b5c406d5b4291ea3cea2039a181594c588abb0e3d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8dde2f4264e1d9cbe81bc56be26d80581a19a363a17dbcd53600ef34dba43c0"
    sha256 cellar: :any_skip_relocation, ventura:       "0b8f1b5868975990c6ab22f2509850c05c2fa5cbc0afe8131f0b9b2e72490e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f6baae7b5b14fad7d2df822947a4049e013b9d454960bb54113fc34871b6e5d"
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
