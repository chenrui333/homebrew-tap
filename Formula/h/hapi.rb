class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.30.7.tgz"
  sha256 "a00bcf85385765d09c953e8b121cac4dc79059e7505352bb36ad5d40492a9395"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4b1c562356ca28d8207cfd1520de7b27600b467ca392ba58106c8871e07c14d8"
    sha256                               arm64_sequoia: "4b1c562356ca28d8207cfd1520de7b27600b467ca392ba58106c8871e07c14d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cf1282b1dcba9ae5032b9c80dc04551548fe7509f35e4cfb10cc4661d9586ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "746e448a57a546399b7c0c281851184d3123a6f08795d751b4ec8dca24f1ef33"
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
