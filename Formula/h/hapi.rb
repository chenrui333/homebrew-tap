class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.19.0.tgz"
  sha256 "c474575c52c349f5202bc359e9497ba5b7187d7d62edf4f2b58aa2ca944ab5db"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "27a426562de3cac31a2441c9e6621372bf4e9e888fd28d8deae0aa6196181cdf"
    sha256                               arm64_sequoia: "27a426562de3cac31a2441c9e6621372bf4e9e888fd28d8deae0aa6196181cdf"
    sha256                               arm64_sonoma:  "27a426562de3cac31a2441c9e6621372bf4e9e888fd28d8deae0aa6196181cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01daf67fda4675bf937c01540e07c4def850bc3d5613cbd0d84c97eedb9bb56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ffe9f2fe228f950b3e3831caf7853cf35e131af8f194df13a9803c1197fd056"
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
