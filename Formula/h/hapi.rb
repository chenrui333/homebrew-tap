class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.14.0.tgz"
  sha256 "f887334187afdad53bade93dc95d0ed69319d6fcb9773dc71686e1c95baafc9d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "c24bb382e2ca150db9e0f91763c1675a92bb5ab8279b89136680c7cc31add19d"
    sha256                               arm64_sequoia: "c24bb382e2ca150db9e0f91763c1675a92bb5ab8279b89136680c7cc31add19d"
    sha256                               arm64_sonoma:  "c24bb382e2ca150db9e0f91763c1675a92bb5ab8279b89136680c7cc31add19d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b0da1ff5e52c49e7d772c291c438e07c12c8a920ad55da4154804c8364a113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0401455efbc2fea03a1f0aeeba3ee8b19a34979a643782f8be0eb4b553ddea"
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
