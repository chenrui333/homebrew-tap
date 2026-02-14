class Context42 < Formula
  desc "Best code style guide is the one your team already follows"
  homepage "https://github.com/zenbase-ai/context42"
  url "https://registry.npmjs.org/context42/-/context42-0.3.3.tgz"
  sha256 "48534ea885d58e2b50727f5f142df76eceffc35c690b38230b89955b88edddca"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e858e7745c04074f5099c97e4a95a25a23c227a65d04edd42b5a9249350baa6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d71f9ed53f6df8010318efdf6c15758fdd7cd82dac62dea660c254b97760629"
    sha256 cellar: :any_skip_relocation, ventura:       "2efeeb92392017e60d603296e3e6eb2c1d86cbff61f764ff1ab26e0c0be15774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eed18dd1126123d50e2d52ed3c8a798b179bcf1fe1bf7518d0ff4706f49a3755"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/context42 --version")

    output = shell_output("#{bin}/context42 --debug 2>&1", 1)
    assert_match "GEMINI_API_KEY environment variable is not set", output
  end
end
