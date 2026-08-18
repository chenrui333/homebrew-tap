class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.28.0.tgz"
  sha256 "f749bb8e24a6566d5cb519c6f29921846b955ade2f0c2f723ce87110ae3b5a21"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "44cffde7678b26edce479040556e1d4a10b777140c703e3e5e0998ca0e3f1567"
    sha256                               arm64_sequoia: "44cffde7678b26edce479040556e1d4a10b777140c703e3e5e0998ca0e3f1567"
    sha256                               arm64_sonoma:  "44cffde7678b26edce479040556e1d4a10b777140c703e3e5e0998ca0e3f1567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88c92f2886258fd34cb57a952619f55cba9e28afd0b189e90e1e9a7293f0430e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839a6f066bfcbdf1a8f2e27234fa45f9229351792720c365fc3debc278d9de80"
  end

  depends_on "node"

  def install
    # Required for the platform-specific optional binary package on CI mirrors.
    ENV["npm_config_registry"] = "https://registry.npmjs.org"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
