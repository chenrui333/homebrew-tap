class Ni < Formula
  desc "Use the right package manager"
  homepage "https://github.com/sindresorhus/ni"
  url "https://registry.npmjs.org/@antfu/ni/-/ni-26.0.1.tgz"
  sha256 "bc65d795986d4d86ad5486814c661c509275f42e6b8aba879157ec082f0dfa1b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4b2b665fcd79ebe898b4c1e10bca7a8d825f2fa2c08a6365c6f27ce042e907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57871b80d90c3436f995fbd8284c2b1a6c91ad20e06e851eac30fdc454feb646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c794d352c89613a4b47f6b5143127da74aab747a4cbf218d23096b0f2d5e821b"
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
