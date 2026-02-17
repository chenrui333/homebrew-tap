class FuckUCode < Formula
  desc "Detect legacy code mess and generate a beautiful report"
  homepage "https://github.com/Done-0/fuck-u-code"
  url "https://github.com/Done-0/fuck-u-code/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "8d8bb9382db388109fa96ea000841c90d6d5fca91f452bf599160830edc08f49"
  license "MIT"
  head "https://github.com/Done-0/fuck-u-code.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5c60b79d5e0f212fff90cd93da78773fb2e0d74d47bc11c097caab5b81729ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c60b79d5e0f212fff90cd93da78773fb2e0d74d47bc11c097caab5b81729ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c60b79d5e0f212fff90cd93da78773fb2e0d74d47bc11c097caab5b81729ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15c0559b4965560531344b796b08064141bf5e3d0a90b3f34f9badf90814d20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7183b33a5c2ec4bc4644634c20292e430d53daf85770535912d34c4a39d74b"
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
