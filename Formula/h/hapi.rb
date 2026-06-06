class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.20.0.tgz"
  sha256 "9e24cea120f278855c255f802db6253ce10c9118af5468d5e0f6fbc40d58d5f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "e82158c72eaf37094cec314fcdb64c7a5790477b9ce99556a53f2c2dd7d04af0"
    sha256                               arm64_sequoia: "e82158c72eaf37094cec314fcdb64c7a5790477b9ce99556a53f2c2dd7d04af0"
    sha256                               arm64_sonoma:  "e82158c72eaf37094cec314fcdb64c7a5790477b9ce99556a53f2c2dd7d04af0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef940de91dcc108a3d06dc18113e2e28ea35eb69052c157d735995b5db7cafe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c38a28f3c89a3eadbb0de90aced43a08c68cc559e103c77acf12b013d0ae82"
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
