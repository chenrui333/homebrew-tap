class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.79.tgz"
  sha256 "471b6e0a2020a6f7c94ac676f8f5dae6b493f26039de0b28b7d67fde18321aae"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e1ce995829314c862f0ef40b63fe9dfa7da6a8c0f076add4b29dfa17f97e70ab"
    sha256 cellar: :any,                 arm64_sonoma:  "00375959c25cce038c806db16f820193c6660507c67dc4d22aff8174ba403895"
    sha256 cellar: :any,                 ventura:       "fcee83ec66ecb11afa7304cff40e6aedafa94102e7917776c8c0df72ededa2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1db413ace6b5e9e106e1b3718f6e87cc6279aff8fed0896a712b953c1acb07"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/yuque-dl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
