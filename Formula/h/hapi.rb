class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.12.1.tgz"
  sha256 "8edf38a268469816048efa53298ef7a361273e0b049d55e39d0850836100817e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a275330acd4a48207ab3deaa75de1b4b6860c2809df765a5e5a64ec62b40053d"
    sha256                               arm64_sequoia: "a275330acd4a48207ab3deaa75de1b4b6860c2809df765a5e5a64ec62b40053d"
    sha256                               arm64_sonoma:  "a275330acd4a48207ab3deaa75de1b4b6860c2809df765a5e5a64ec62b40053d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4471bb8213b9c321608a84b9fc4f60844025188a4774fbcc55da4c2d586afb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f9da890e92448b189bdd4a57721799e6e76ac17f3de62bc86b96d5cacbe003d"
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
