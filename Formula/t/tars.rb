class Tars < Formula
  desc "Local-first autonomous AI supervisor and sidekick powered by Google Gemini"
  homepage "https://github.com/agustinsacco/tars"
  url "https://registry.npmjs.org/@saccolabs/tars/-/tars-1.25.0.tgz"
  sha256 "3702df4478d762ea17f89597f2f4862a09da4cf83eb8868147f102b8f268165f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8015ac0c0f1d560f5eec19917f7a53aa9d8b52febe4b00520bb695549cc8b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8015ac0c0f1d560f5eec19917f7a53aa9d8b52febe4b00520bb695549cc8b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8015ac0c0f1d560f5eec19917f7a53aa9d8b52febe4b00520bb695549cc8b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7446f5251f407240c1a26c8cd7b61901fa30e85ac2ac9047395856734e9774bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77bc41b55ac21dff08bf3c60748fdf34303a957f77e50ea91987fcbbb6cb6cdb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds for non-native architectures
    nm = libexec/"lib/node_modules/@saccolabs/tars/node_modules"
    if Hardware::CPU.arm?
      nm.glob("**/prebuilds/darwin-x64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-x64").each(&:rmtree)
    else
      nm.glob("**/prebuilds/darwin-arm64").each(&:rmtree)
      nm.glob("**/prebuilds/linux-arm64").each(&:rmtree)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tars --version")
  end
end
