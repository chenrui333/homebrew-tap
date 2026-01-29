class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.15.0.tgz"
  sha256 "f99d20a10b21345763ebdf8343fb50d2ab91a94893bbeb6a7459a82ea710c96b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "869827ef036cbe357c09ad9c721fe074af4e450682349f3d135a13161cdb2d1d"
    sha256                               arm64_sequoia: "869827ef036cbe357c09ad9c721fe074af4e450682349f3d135a13161cdb2d1d"
    sha256                               arm64_sonoma:  "869827ef036cbe357c09ad9c721fe074af4e450682349f3d135a13161cdb2d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ef84acc1d1a5e37aa9091a18db829ea4a53c501306a6ac5b9b56b6413e8915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85fb732b6ba6563f5f503acb6cfaed81763dd2a7357072c4b4f42d83998868b"
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
