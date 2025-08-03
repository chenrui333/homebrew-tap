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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "576a4455e10dec0b1f3255c80a44993d392780fbf19eed3a14595f1a6f0d6163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a357120da58aad11a8376ab4577985f8af6ab633fe9ebc23a4fcff7601024ea"
    sha256 cellar: :any_skip_relocation, ventura:       "e28430835e207eb5de5b9a0cc3ce570bac4bc0a975dd9afc7d677d381459ec4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c150350e8e1f2b360344d2cb533dde8ba214943088cbc2a29f483740cddeb1b"
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
