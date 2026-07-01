class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.15.tgz"
  sha256 "309985d7b111ed8620d7494d2920bb242d922e8a0529bb9d73cdba2950733903"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3020c226fd9679c32b50bb32af1127aa6803700832adcbd1949e0c644bd81a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3020c226fd9679c32b50bb32af1127aa6803700832adcbd1949e0c644bd81a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3020c226fd9679c32b50bb32af1127aa6803700832adcbd1949e0c644bd81a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5c1b4c61ecb8047fb7390fd9223a9ba2448b0a95ff5f049361655c0858ec855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5d053d06a3023b5f9d51656ad00c5ecf8e01cfbdfa497c565ef8d5e6c8d9e1"
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
