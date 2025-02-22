class Npkill < Formula
  desc "Easily find and remove old and heavy node_modules folders"
  homepage "https://npkill.js.org"
  url "https://registry.npmjs.org/npkill/-/npkill-0.12.2.tgz"
  sha256 "039d6c3118667d1ae53751e45e8bd6b97c32cbbe7f7416ca4b7c9fc4c272c399"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/npkill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npkill --version")

    (testpath/"node_modules").mkpath
    output = shell_output("#{bin}/npkill -y --directory #{testpath} --json 2>&1", 1)
    assert_match "Oh no! Npkill does not support this terminal (TTY is required)", output
  end
end
