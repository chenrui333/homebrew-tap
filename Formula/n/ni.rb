class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-24.0.0.tgz"
  sha256 "bc23cc18f58563f8defb0f84715c6c1473549463891130a2c662466edf782a67"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1427be3c7d9098d7ec41d9a37c525500fb611718d68bd4c2711e71433a6d74d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ce07aaa68a25ed036bf19d02fe9129ca8aee301281969309e61b7ad6a4edba"
    sha256 cellar: :any_skip_relocation, ventura:       "a96a1cf46e3df0a8df53a01be508bacf693dd0e8195486769f20f72206842a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cece2020f7914c81a45ca9847aa3ab60a5cbbbb323415ec5e0faa6bd24450171"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ni"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ni --version")

    (testpath/"package.json").write <<~EOS
      {
        "name": "test",
        "version": "1.0.0"
      }
    EOS

    output = pipe_output("#{bin}/ni", "npm\n", 0)
    assert_match "found 0 vulnerabilities", output
    assert_path_exists testpath/"package-lock.json"
  end
end
