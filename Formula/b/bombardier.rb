class Bombardier < Formula
  desc "Cross-platform HTTP benchmarking tool"
  homepage "https://github.com/codesenberg/bombardier"
  url "https://github.com/codesenberg/bombardier/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ecab7b58a5f7fbb74ca390e3256522243087a7ad41f167eead8a62b4c19c12a8"
  license "MIT"
  head "https://github.com/codesenberg/bombardier.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3b598724dfca13dd47af122864bd098e862054e75be5109a982461bf78fadd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d5bc6bf052ff1a1f2833f70bb6b4fb193b9c5d303b981505f5ff271472e6a26"
    sha256 cellar: :any_skip_relocation, ventura:       "cdd0ef609bee5846a2b1a3556422f66819701349c0ac90000c282d5c79bd7a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0363490a5d9b55df4bb0ff86b312533d54588e89961d63489cba81c600fce6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bombardier --version 2>&1")

    output = shell_output("#{bin}/bombardier -c 1 -n 1 https://example.com")
    assert_match "Bombarding https://example.com:443 with 1", output
  end
end
