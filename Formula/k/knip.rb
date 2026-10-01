class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.39.0.tgz"
  sha256 "eda83ec20de855acedf000f9259cba17219d4a290a2644d3e685c24f42f22f83"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1a1a7ed2758d086a5b63cba53742b31bc7f9befe39bb526ad42fcdbba23bfa6e"
    sha256 cellar: :any,                 arm64_sequoia: "1a1a7ed2758d086a5b63cba53742b31bc7f9befe39bb526ad42fcdbba23bfa6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c13d12b06e3acf90178743582b3a2e7081424c7dba7abbfb8ff234b535c20f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ada78bef7890ac366b788fb330c0a22bf9b244533a5bbb63d2bd44151b81a71"
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
