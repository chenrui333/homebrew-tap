class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.18.1.tgz"
  sha256 "df83d27da59e83fe9193bd7acce39cdf758f54e3ee8a9972a879b7791f84b021"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "5c4a89cac47ebb2de9510ce49169e9a4242f07ef52378d5581bc657fc24cb125"
    sha256                               arm64_sequoia: "5c4a89cac47ebb2de9510ce49169e9a4242f07ef52378d5581bc657fc24cb125"
    sha256                               arm64_sonoma:  "5c4a89cac47ebb2de9510ce49169e9a4242f07ef52378d5581bc657fc24cb125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de9ff5a9d5c91a72a28a9ee6ae6b431c3c66caeed38dbdf837a0444efe5081f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf73559dae2d8dcb82e7bf67b31172b016d50a50541c32f746ac1bb039f1738"
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
