class Pixeli < Formula
  desc "Merge images into customizable grid layouts"
  homepage "https://github.com/pakdad-mousavi/pixeli"
  url "https://github.com/pakdad-mousavi/pixeli/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "91de06b777e62d561495a14c660b1fbfca3c4039feba291be983030db80fa490"
  license "MIT"
  head "https://github.com/pakdad-mousavi/pixeli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ad4d1cf356d2ffc0d8f7cc83be5a48cb3e728d83cfeb68b3d985f6e3ea2f89a2"
    sha256 cellar: :any,                 arm64_sequoia: "113535aee3a78b0cdef0f2fdd1103c3d41e904304f977657f9901bc9a6994dd7"
    sha256 cellar: :any,                 arm64_sonoma:  "113535aee3a78b0cdef0f2fdd1103c3d41e904304f977657f9901bc9a6994dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254362531007b2bf7689d703c4a990ffb5a8bb502e81178b6c6cc08794f11bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebd74f5ecf8a1d4a05146c23608d10a35717b07811de90dc768c924bda3cbfb"
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
