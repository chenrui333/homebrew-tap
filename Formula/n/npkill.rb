class Npkill < Formula
  desc "Easily find and remove old and heavy node_modules folders"
  homepage "https://npkill.js.org"
  url "https://registry.npmjs.org/npkill/-/npkill-0.12.2.tgz"
  sha256 "039d6c3118667d1ae53751e45e8bd6b97c32cbbe7f7416ca4b7c9fc4c272c399"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2497452f0965fdeee1c803f03bcdd4a1599b065779ba6c1e1aab5e22a6f571e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebd12718903ab9a7edf3343d26c5b8cc63b9427cf98d72a787d74999d952181"
    sha256 cellar: :any_skip_relocation, ventura:       "9ac8a4a691d45b9ac0818ae10fc49c9b76ec03789dcf428de67f304f449e1436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c8b9d6837cc44cb1c7178f964b6c1efa94fae2868fd003d545f6ebed049080"
  end

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
