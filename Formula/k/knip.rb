class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.81.0.tgz"
  sha256 "a1856879a18e5be2d430c5bcf34671797528ee3997a435f3f130e55b49675d17"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "bffcd26e7b1e7443ecd0fb3ae4a94fb48723b032a12ba47380263e969b0c3f73"
    sha256 cellar: :any,                 arm64_sequoia: "4350bec9b599aa044016c33690ab80a2059f8b310c841ce0210d13d57ef491be"
    sha256 cellar: :any,                 arm64_sonoma:  "4350bec9b599aa044016c33690ab80a2059f8b310c841ce0210d13d57ef491be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd4a65858321a56a21f2829984904819e2978cd9b5ba73132b1340b0a0c3e8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1f7a1c1de2435232f2c48a2282fb0bc98f36bdacf6218a80b8b80ca6f8c6e68"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
