class Knip < Formula
  desc "Declutter your JavaScript & TypeScript projects"
  homepage "https://knip.dev/"
  url "https://registry.npmjs.org/knip/-/knip-6.34.0.tgz"
  sha256 "c68ab497aaeee9fb5f6a21d7d9f276ac1a3a0c2908bf19e80a576b5ff2c8d910"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a3e171f5b90a566e7fd897147cfc52ce7adcdac3d60a644ea26f6892255d55a7"
    sha256 cellar: :any,                 arm64_sequoia: "a3e171f5b90a566e7fd897147cfc52ce7adcdac3d60a644ea26f6892255d55a7"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e171f5b90a566e7fd897147cfc52ce7adcdac3d60a644ea26f6892255d55a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64d5dbb120ca3e44c4b28d2658844215d2667d87f797e1c6e8d92340d402726f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcda5e01d7392415017474baed3945b2e78ccd0f02c5f30b7dd4f10e4ade749a"
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
