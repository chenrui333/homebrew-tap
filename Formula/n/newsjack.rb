class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.16.tgz"
  sha256 "754d975ae8620f85bb413baf9905e53dff6472b8d8f7dd55b13c4f908ab617c5"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcda400e7467f0167fb093df8dc2b514fef084ac3304397ec3f1063f913a9b9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcda400e7467f0167fb093df8dc2b514fef084ac3304397ec3f1063f913a9b9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcda400e7467f0167fb093df8dc2b514fef084ac3304397ec3f1063f913a9b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84fc5b5d42bf5dc00a0c560dfe684eb3d16b1abea3a8f26d019cbda7473d2b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34bd2070250c9a571fa22c475e292d2035e1440fb2e17b3e06b28a8dd345ae21"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")
    assert_match "newsjack", shell_output("#{bin}/newsjack --help")
  end
end
