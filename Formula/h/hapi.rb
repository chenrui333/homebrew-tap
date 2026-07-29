class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.25.1.tgz"
  sha256 "ece75191699f71f981cc357cef1d103d0f456950ecd42bb948b6f1ba93647ce9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b45c765623d9251ac68570f5cbc2fc837fca6a496d116872d3b757c52df66353"
    sha256                               arm64_sequoia: "b45c765623d9251ac68570f5cbc2fc837fca6a496d116872d3b757c52df66353"
    sha256                               arm64_sonoma:  "b45c765623d9251ac68570f5cbc2fc837fca6a496d116872d3b757c52df66353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06496ccb7781d12a34d8254c88914e09f0c87f46f0c521eedb787ae2d549f2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af84759a865fe60957f1b45ae7447bdf69c8ba0df8143e018c68f7152557a88"
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
