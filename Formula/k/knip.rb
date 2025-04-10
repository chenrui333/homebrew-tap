class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.50.1.tgz"
  sha256 "c5749844a9c1b5e4f40451d13a33baaaf742d03fadef4c9c8446a20516e1e470"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed583541ee4b46af7f4328f8a8cf5cdde17f7dd04520f3af2881dafffded1fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a43bd21368900354463ec918eed610f17b77449f87e4093e62267f8ddd510d"
    sha256 cellar: :any_skip_relocation, ventura:       "5184885b294d2161f376c05a773a1ccb41ce22b7944853794cc139d3758de40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77b58ae45e2aa6a6d801810b2eac48a68416861a771f5554285baeee740d69b"
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
