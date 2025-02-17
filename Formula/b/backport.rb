class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-9.6.6.tgz"
  sha256 "c8b1bfa09bc54adb24369ff807c85b425607aa3fc557e1aab5601ebe7e5eb1b4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde28c0cbb05e56b90748244eefb326f865e7980ac695d07f154270e8a126feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a63f6c57a36cf98c4dc03a1112c29fd2a138655b3ef60814dbc5cae40fd339c9"
    sha256 cellar: :any_skip_relocation, ventura:       "f9031e46eb014396479fca82fc3bc4728ab8645cc78e5fca6795da76e98255f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056cb232bff00b6c37ecf19a8e492457239296d2d6ad24a92b2a6cf49e1a03ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/backport"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backport --version")

    (testpath/".backport/config.json").write <<~JSON
      {
        "upstream": "elastic/kibana",
        "branches": ["7.x", "7.10"]
      }
    JSON

    output = shell_output("#{bin}/backport --dry-run 2>&1", 1)
    assert_match "It must contain a valid \"accessToken\"", output
  end
end
