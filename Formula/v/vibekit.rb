class Vibekit < Formula
  desc "Safety layer for your coding agent"
  homepage "https://www.vibekit.sh/"
  url "https://registry.npmjs.org/vibekit/-/vibekit-0.0.4.tgz"
  sha256 "0d636445799fc10b0b9c46ad84030f562cddc1f9f70d010fe59357c3f871c19a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81d83eb11ed8a8f8d109840856ce28585084ff258066aae2ae066da4947214a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "138487a1e87094f66530af0a2a4ccf29186d0c0fc4f539bec0cbc89295864381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38eed45de476dfa9d960d6d4c1171549258ffdceac83f0e04ceda8c2fb3413ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibekit --version")

    expected = if OS.mac?
      "Status: DISABLED"
    else
      "Status: ENABLED"
    end
    assert_match expected, shell_output("#{bin}/vibekit sandbox status")
    assert_match "No analytics data found", shell_output("#{bin}/vibekit analytics --summary")
  end
end
