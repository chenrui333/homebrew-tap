class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.17.3.tgz"
  sha256 "f253ac9d1ea1d17b73641071102574576c2c46b8f21869d21594538f990daf8b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d185735279a681a884160d4f3c40fa59bd7202f702b9d9ffc8e909fe61b1937d"
    sha256                               arm64_sequoia: "d185735279a681a884160d4f3c40fa59bd7202f702b9d9ffc8e909fe61b1937d"
    sha256                               arm64_sonoma:  "d185735279a681a884160d4f3c40fa59bd7202f702b9d9ffc8e909fe61b1937d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f490b2cd1a5e12f7aa0f69c327bd4a9f0c4dfdba7a85fd1c0af6d99c02633ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd50042fe7fdef9a7f2081e66f66e7e1e32fd94af9c23ea36ad10fab03a6f89"
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
