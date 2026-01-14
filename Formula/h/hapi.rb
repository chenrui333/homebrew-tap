class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.8.0.tgz"
  sha256 "24acf523b0c7a3bb6c316a9544c842592a25e808b33a62b9846474844ccba708"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "aedbbabbd0a9e94c3593f5b4db5d814ccb67f6d78a092518ae65775852421012"
    sha256                               arm64_sequoia: "aedbbabbd0a9e94c3593f5b4db5d814ccb67f6d78a092518ae65775852421012"
    sha256                               arm64_sonoma:  "aedbbabbd0a9e94c3593f5b4db5d814ccb67f6d78a092518ae65775852421012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd927bab2b15d01a62b2873b975b4ff41abfa51664dff755360f9bd0b327f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44fdd7b073a0de09fac8e4a347a5527873bad5130b5eda6de4bd010c7b090821"
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
