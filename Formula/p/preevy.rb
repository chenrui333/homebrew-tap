class Preevy < Formula
  desc "Quickly deploy preview environments to the cloud"
  homepage "https://preevy.dev/"
  url "https://registry.npmjs.org/preevy/-/preevy-0.0.66.tgz"
  sha256 "aae290aabc6046dc7770d853888dd9a7c13e57f3aa68397e249c2af608fd0460"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "7d0ebd2d57b55acc109497cf1a6da06fd989d1254b8dcabee03cc01726b921d3"
    sha256                               arm64_sonoma:  "0ad50dba46d862991bfb9492ed0539aceca95e6cbbcef1cff33d632e436223aa"
    sha256                               ventura:       "45b6c86876641dc1e74056c2c899b70d68231bf384ba91c51c928c7fb5d684b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b830f88b375f79fe4af61ff78b082e404fbabbe0baed9f5c8350d68c6c73771f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/preevy --version")

    output = shell_output("#{bin}/preevy ls 2>&1", 2)
    assert_match "Error: Profile not initialized", output
  end
end
