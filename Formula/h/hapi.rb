class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.0.tgz"
  sha256 "018671f4db07ea3b4c5205f6d170f7fb6bec653aa36494078a478aaf0697f451"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9935afb9cd33b76b3b50fa17b4af092a878ae6ea480532526fd802726159cee4"
    sha256                               arm64_sequoia: "9935afb9cd33b76b3b50fa17b4af092a878ae6ea480532526fd802726159cee4"
    sha256                               arm64_sonoma:  "9935afb9cd33b76b3b50fa17b4af092a878ae6ea480532526fd802726159cee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f9a40b50b3ad8fb9eefe6a731a31fe8978fe185418b2b5c41a97c1e641a540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1167bfadbc296bc6a40336abb87e86d6e2b3e01e844ce511c83e2064ef1b2fbd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
