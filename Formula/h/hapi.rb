class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.27.0.tgz"
  sha256 "998a1f28a1b8262faed6f4b247249bb517fed2ec1ad23dee14c3dd267b6d8a5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "aaa788bf7528d9b14b8d610d407b5d710d2fcfd58570a35bdf66ad9238cd71cf"
    sha256                               arm64_sequoia: "aaa788bf7528d9b14b8d610d407b5d710d2fcfd58570a35bdf66ad9238cd71cf"
    sha256                               arm64_sonoma:  "aaa788bf7528d9b14b8d610d407b5d710d2fcfd58570a35bdf66ad9238cd71cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "636c2f1eff7cafa0154f02ed40c0bc3e2dc7f11f837ad43a6874d87a54c8272c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c323369738e49c42051a9a94d173e67591634c83ca31d3b9465e7ccaeff8de"
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
