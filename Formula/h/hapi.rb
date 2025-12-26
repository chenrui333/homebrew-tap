class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.2.1.tgz"
  sha256 "6ced64dad884caf00857b1eb388632e8aa78d70e4015d71adc15fef0d7fb9331"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a09bbe81fb17116d4175655808c62e3c7e3205747c0d57eb916e80c3b4303cfc"
    sha256                               arm64_sequoia: "a09bbe81fb17116d4175655808c62e3c7e3205747c0d57eb916e80c3b4303cfc"
    sha256                               arm64_sonoma:  "a09bbe81fb17116d4175655808c62e3c7e3205747c0d57eb916e80c3b4303cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4672d050e946b7c73c877e2db497c5087db68659486288dcd00693d63fdc46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b237370a963d26ae002e07879fac879e3e8ad2d03330e34cad0c8b2b22c3db"
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
