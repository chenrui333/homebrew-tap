class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "a6c7db263e3b2239147c1ef66b6f15d170badb8b82605bdc2fa086cb3478b768"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22479efe83e91aa062fd4ddd184fb19665b0bbf39258498e5be0fa319fc22ae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22479efe83e91aa062fd4ddd184fb19665b0bbf39258498e5be0fa319fc22ae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22479efe83e91aa062fd4ddd184fb19665b0bbf39258498e5be0fa319fc22ae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05bc2cd399eded70f19ed320bba260c3c56540bf3169b5d123f5d800e1af8fd0"
    sha256 cellar: :any,                 x86_64_linux:  "70ebadaaf20bdfbbe3986b31ce8904009ca877b07d00e8f002f6accd22ad9d4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
