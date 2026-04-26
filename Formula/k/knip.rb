class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.7.0.tgz"
  sha256 "c7a4f5e4146b352629dd5309282df830e3e782a953780413a982ff9f27a8ecf1"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "33d1f4f006b01bea34fc28a41cc475a2b3495f5ae7800c459f83cf8a1be7a4ab"
    sha256 cellar: :any,                 arm64_sequoia: "66e5da3a6baee5d4a04f48c11d5f6d7a36cdb8a0fb65935580569bd306b7fbdf"
    sha256 cellar: :any,                 arm64_sonoma:  "66e5da3a6baee5d4a04f48c11d5f6d7a36cdb8a0fb65935580569bd306b7fbdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86accdbaf08a3a4c7bb02da2090468ffb179163a57f96090e5c3f93805b91905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c50057ed30ca3bd97ef14f677babf5e599b226d246db1049cce73e1313c5f73"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    assert_match version.to_s, shell_output("#{bin}/knip --version")

    system bin/"knip", "--production"
  end
end
