class Pixeli < Formula
  desc "Merge images into customizable grid layouts"
  homepage "https://github.com/pakdad-mousavi/pixeli"
  url "https://github.com/pakdad-mousavi/pixeli/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "91de06b777e62d561495a14c660b1fbfca3c4039feba291be983030db80fa490"
  license "MIT"
  head "https://github.com/pakdad-mousavi/pixeli.git", branch: "main"

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
