class Taskonaut < Formula
  desc "Interactive CLI tool for exec into AWS ECS tasks"
  homepage "https://github.com/SchematicHQ/taskonaut"
  url "https://registry.npmjs.org/@schematichq/taskonaut/-/taskonaut-1.10.13.tgz"
  sha256 "436b0abeac49e1828b23ca3bcf82962c76dc478152d012f1114f01bda1601ee5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9423bf429f3ec54af1f0688088e37a75c7afa71ccee192cade71da8ef8a5cd21"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/taskonaut config show")
    assert_match "\"awsProfile\": \"default\"", output

    output = shell_output("#{bin}/taskonaut doctor 2>&1")
    assert_match "❌ AWS profile 'default' is not configured", output
  end
end
