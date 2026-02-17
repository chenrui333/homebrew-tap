class FuckUCode < Formula
  desc "Detect legacy code mess and generate a beautiful report"
  homepage "https://github.com/Done-0/fuck-u-code"
  url "https://github.com/Done-0/fuck-u-code/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "8d8bb9382db388109fa96ea000841c90d6d5fca91f452bf599160830edc08f49"
  license "MIT"
  head "https://github.com/Done-0/fuck-u-code.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d9ced27d83d9b5f5bbf1d7f4eb0fd281513e7c0b2f67b42255e8c7a502935b83"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"main.js").write <<~JS
      function greeting(name) {
        return `Hello, ${name}!`
      }

      console.log(greeting("brew"))
    JS

    assert_match version.to_s, shell_output("#{bin}/fuck-u-code --version")

    output = shell_output("#{bin}/fuck-u-code analyze #{testpath}")
    assert_match "Code Quality Analysis Report", output
    assert_match "Overall Score", output
  end
end
