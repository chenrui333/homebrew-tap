class Oui < Formula
  desc "MAC Address CLI Toolkit"
  homepage "https://oui.is/"
  url "https://github.com/thatmattlove/oui/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6c63611297b9d24356433dcde989e4904196bad390c35e5c7846d063ec451f6b"
  license "BSD-3-Clause-Clear"
  head "https://github.com/thatmattlove/oui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af9dfdabebef6b14d7253dc13859ced725535e3421988b0e2c95799087749d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af9dfdabebef6b14d7253dc13859ced725535e3421988b0e2c95799087749d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af9dfdabebef6b14d7253dc13859ced725535e3421988b0e2c95799087749d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85a46adeb8e581829583c46eca62c8b07e8774c62f52c3df545c8ffb3f7de65"
    sha256 cellar: :any,                 x86_64_linux:  "aad3b8a877e489f673d8e552ffab85f6269d1251675036b16243ebb8bc22ad41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oui --version")
    output = shell_output("#{bin}/oui convert F4:BD:9E:01:23:45")
    assert_match "{244,189,158,1,35,69}", output
  end
end
