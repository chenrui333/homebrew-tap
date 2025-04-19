class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.79.tgz"
  sha256 "471b6e0a2020a6f7c94ac676f8f5dae6b493f26039de0b28b7d67fde18321aae"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "2c37a4efff1d09a7053f1366e716c63bacfe2e13942ea693250c48caadd4b05b"
    sha256 cellar: :any,                 arm64_sonoma:  "aece2e0bd9e2e7060da082a41ab897ed0d09d493dee10c626f8925ef0c5ac14b"
    sha256 cellar: :any,                 ventura:       "e33803cba743b9b25a709f2ebc0615ecf63eba9b095b2994fb593cb0815a576e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a0d2c8b088e0b8ea64f99225925cf1cfb9892451ef5da9c7501cf1c8cfa39f"
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
