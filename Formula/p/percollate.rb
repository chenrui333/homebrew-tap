class Percollate < Formula
  desc "CLI to turn web pages into readable PDF, EPUB, HTML, or Markdown docs"
  homepage "https://github.com/danburzo/percollate"
  url "https://registry.npmjs.org/percollate/-/percollate-4.3.0.tgz"
  sha256 "5d3c9949da181b9d9f2011595434801e730637c6e728920191bdc5c458d87a92"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41118a0a859d3ea4479cc12fcb9dab8da674e1020f47880b93cd1491a24407e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118f26b9f8c9400ffae1ef23972ac42dff1bacd2585398ef6d120908a43ce17f"
    sha256 cellar: :any_skip_relocation, ventura:       "745549bb4fcd54307b883ddbdfd0608df9a5ef3827782222e994e8ab07d1c538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "affbb97c4ec7856895b7846f739f67e33b3d178b9ab6c6b29151c082bc10f8bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/percollate --version")

    # Since percollate requires Chromium, just do a error check in here
    output = shell_output("#{bin}/percollate pdf https://example.com -o my.pdf 2>&1", 1)
    assert_match "Could not find Chromium", output
  end
end
