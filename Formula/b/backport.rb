class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-10.0.0.tgz"
  sha256 "e1d800d2aa975920389323a41c8c08174f1b94c60c9d69854f7f6d4cffd19150"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "691a16b16a300da4b3312c170c5914211bc472affcc04c3803138b19628d9f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77c3868153575bcfd0f4a04a7416ed91b5444eaa3a7ecdbbc9a7a1264f1153c"
    sha256 cellar: :any_skip_relocation, ventura:       "15809d27e36e7aa8607a97b9752b1a57afcf4808a71c83aa8215a595ea4e88d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfb40e043639826f8f115e820bb8ec670ad87fc775c6041cf8e18228f668888"
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
