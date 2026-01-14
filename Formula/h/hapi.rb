class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.8.0.tgz"
  sha256 "24acf523b0c7a3bb6c316a9544c842592a25e808b33a62b9846474844ccba708"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "162f4e3c659c933cf4e5a71ee66245f78ec975666fd4f75a0e03dbe4721da524"
    sha256                               arm64_sequoia: "162f4e3c659c933cf4e5a71ee66245f78ec975666fd4f75a0e03dbe4721da524"
    sha256                               arm64_sonoma:  "162f4e3c659c933cf4e5a71ee66245f78ec975666fd4f75a0e03dbe4721da524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5406ee6c99e109e683f8a6ed5eb10138f071ebedd5c1f4984bb483f225c0361e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e0072ab2e683cff98929d2c3f179b108cd7ac20dd3504f71caeede40dfe164e"
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
