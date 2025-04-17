class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.50.5.tgz"
  sha256 "6895d459cce4bbf704a15a5c6eeb2d6f477c10babf443d95228235bc70bf41a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b88a7a0edcff53c966316b2d3cfddb4b2da6064312d58691d6386da33bb9ddbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc4bff62bffbd4cd79b24a58f6b5e314c00c6a169eaf3ff2b7a461cb89738e8"
    sha256 cellar: :any_skip_relocation, ventura:       "5a21e7bec6fed2352d6924c2873d4debdd56e938d0d1ea65cff6e4e7b9143d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce1a25b10f06f58eed0bcc61119bff373d09cac1729c7aa0915a435357643174"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knip --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "my-project",
        "scripts": {
          "knip": "knip"
        }
      }
    JSON

    system bin/"knip", "--production"
  end
end
