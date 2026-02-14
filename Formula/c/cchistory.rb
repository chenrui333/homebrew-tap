class Cchistory < Formula
  desc "Like the shell history command but for your Claude Code sessions"
  homepage "https://github.com/eckardt/cchistory"
  url "https://registry.npmjs.org/cchistory/-/cchistory-0.2.1.tgz"
  sha256 "41fd78b3488e40677d48017860ae499ac788436d1fb065ff095526b133f3edb8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe709de2042a37a0a5cf3143d890ffc34110bf6f397439676576b9c66dbad1de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a519db045f61817c7f6be91362608d1531e5afed52586450169cbcfa8acdb46"
    sha256 cellar: :any_skip_relocation, ventura:       "04871830f05f13aa1ca05fe0c57809f2940eb2c9a6295753d850159fd4c952b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef49f9b12592705c36ccd727b9b7b04f6e664079736f84151461aa92207e5a43"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cchistory --version")
    output = shell_output("#{bin}/cchistory --list-projects 2>&1", 1)
    assert_match "Cannot access Claude projects directory", output
  end
end
