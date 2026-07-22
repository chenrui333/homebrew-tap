class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "a6c7db263e3b2239147c1ef66b6f15d170badb8b82605bdc2fa086cb3478b768"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "999a0cfcd070eb2ec2e831de49b744ae5772f1d669ef9f6d676e6c8bcc8938d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "999a0cfcd070eb2ec2e831de49b744ae5772f1d669ef9f6d676e6c8bcc8938d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "999a0cfcd070eb2ec2e831de49b744ae5772f1d669ef9f6d676e6c8bcc8938d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a8abfd53437dff64562f27a01caaaf8e61a2001e059fcb0991b44654ada68ef"
    sha256 cellar: :any,                 x86_64_linux:  "78975e654a1190bc6f03099f59e576752332fedd23bbc52eb67dcc73e621a7e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
