class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.2.2.tgz"
  sha256 "2c5e50a51fe0ad383fdc17d5aa51e585482db275108e0c2ce72434125bf90a4a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3eabc47902c16fd163ba9371853e2e3e989cdb06234f15eb78d0dd4a29b15daf"
    sha256                               arm64_sequoia: "3eabc47902c16fd163ba9371853e2e3e989cdb06234f15eb78d0dd4a29b15daf"
    sha256                               arm64_sonoma:  "3eabc47902c16fd163ba9371853e2e3e989cdb06234f15eb78d0dd4a29b15daf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "621788cf3fcc28576fa6b13d837d4cbe69af4b3019e34dd08bcad439377ed0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91371dc9cc799e4405b94e96af621637b4c7f4dd073ba0d3f0e7ba7070418504"
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
