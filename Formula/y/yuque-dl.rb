class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.81.tgz"
  sha256 "41039640509fd213938a7c412fec8a43492d52d30bf3fbdcf5f34c905c7a5b8c"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "932c8a8a2caeefd1d17c1e5d8de5ea0d45cfe751e9eaab404638290587c1d297"
    sha256 cellar: :any,                 arm64_sonoma:  "c5a6410bad99c006e824f55f5bf9e2bb23d3b99a4e3033730fff503cfc39c17d"
    sha256 cellar: :any,                 ventura:       "8ac160a30391d920758d82185923fb02c909d37c4cb80640dc7ba56e4dfe03fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd58e5805f410119743397b51f86db3c87d02e53c51e71fa7b7329338641cac4"
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
