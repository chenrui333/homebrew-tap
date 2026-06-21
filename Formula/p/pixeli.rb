class Pixeli < Formula
  desc "Merge images into customizable grid layouts"
  homepage "https://github.com/pakdad-mousavi/pixeli"
  url "https://github.com/pakdad-mousavi/pixeli/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "a001c6a9780b983528417e724afd9860b8e7b4aa3786fccf71e8817d4ff36d33"
  license "MIT"
  head "https://github.com/pakdad-mousavi/pixeli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "7384cd81856d25d9ae49983041b0e50eee9e3739d5e0dd99a0575c361015abad"
    sha256 cellar: :any, arm64_sequoia: "93c7e1d81ac460360dfc00d8c404ccf18db5c0c3ffd2b9913746485270e52c34"
    sha256 cellar: :any, arm64_sonoma:  "93c7e1d81ac460360dfc00d8c404ccf18db5c0c3ffd2b9913746485270e52c34"
    sha256 cellar: :any, arm64_linux:   "063b4a4aa5b3613735d73e40db75f034634d77cbd123e73f6024dd020b24ecfd"
    sha256 cellar: :any, x86_64_linux:  "7f0ef367e7c41a3b530f04f2fe930b2a87226bee3cb0a6c81aa0f0dd90db44e9"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    bin.install_symlink libexec/"bin/pixeli"
    pkgshare.install "src/tests/test-images/small-image.jpg",
                     "src/tests/test-images/large-image.jpg"
  end

  test do
    output = testpath/"out.png"

    assert_match version.to_s, shell_output("#{bin}/pixeli --version")
    system bin/"pixeli", "grid",
           pkgshare/"small-image.jpg",
           pkgshare/"large-image.jpg",
           "-o", output,
           "-c", "2",
           "-w", "100",
           "--gap", "0"

    assert_path_exists output
    assert_operator output.size, :>, 0
  end
end
