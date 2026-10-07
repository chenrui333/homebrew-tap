class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "a6c7db263e3b2239147c1ef66b6f15d170badb8b82605bdc2fa086cb3478b768"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f17866932751a483eee57a6af68d8f913540c5d8670b11cde41e297d8a5a448"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f17866932751a483eee57a6af68d8f913540c5d8670b11cde41e297d8a5a448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7cf4d930eb46f3cbd206cf5a933d8f798aa0f30334f277b752fa9743093a0d7"
    sha256 cellar: :any,                 x86_64_linux:  "8bb12eeeda734af96a38f129748e9008ae9641e465d18b2aaa4d8296d456c19d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
