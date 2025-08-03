# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "ddac999640e91327d084ea0186ae334f0ec8151177d816d5b6b6ff59030feb69"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3f267673671d8a8e2e73d5d8267cd90a15edcfd930147654168900af68d7ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c27e11cea8635cedd773f2df030b1fd71d781ad4a0b150e96952ab2ae0740b"
    sha256 cellar: :any_skip_relocation, ventura:       "70690818f1870bb6a206bbb8a1a4af449a7a3fa60f12b7a554e35543230e6a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76f800444ae5b4731ca15e12561da184ffc21d7b8ba53aaf254cf2a9d5c69a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
