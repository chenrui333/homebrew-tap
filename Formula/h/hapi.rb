class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.3.1.tgz"
  sha256 "98e7b0af27c9c48c9f46c11e0dd7c09cda42866c6b70055b7fbcaa7c7238e7b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "71528aed315f1269b36511d31c8ef963a4647284c2e8d9b4b8cda57bd4721c29"
    sha256                               arm64_sequoia: "71528aed315f1269b36511d31c8ef963a4647284c2e8d9b4b8cda57bd4721c29"
    sha256                               arm64_sonoma:  "71528aed315f1269b36511d31c8ef963a4647284c2e8d9b4b8cda57bd4721c29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "285757a4819003ada06e56e4a3f43bccd8200e438832f7910562f0b0d7ddc893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879a74b34f8a3dc1dd062850e183b316559cec77567830e8dcf8c1a843700b7a"
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
