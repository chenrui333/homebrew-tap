class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-5.77.1.tgz"
  sha256 "ac016b27abe1e2297736e3af1a706fe394a42d33f1b065beee1b85e66a5cc097"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b6950233058161c3e06287334b60793d86ab66c5409c24b9ddfd472b55adf28b"
    sha256 cellar: :any,                 arm64_sequoia: "4ecc5bb0dcc0156a4731f527b668aced4f0312752e72486447876491ced97da3"
    sha256 cellar: :any,                 arm64_sonoma:  "4ecc5bb0dcc0156a4731f527b668aced4f0312752e72486447876491ced97da3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34055167946c647c531afb449afbda80dabdf133d3ec9d43f3454fc90d54672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34473b704f196b01ea6715fc77a80a9ac8221352caf1eb72637b8e1bf6530b5"
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
