class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "51abb7fe97e1a414465fdb9a034c5472ea62e96c05f1fe6114656c7ec19d22ec"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7923769ae6e5a774a46f3800a962385b816a422913bdda015c802d642978f81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7923769ae6e5a774a46f3800a962385b816a422913bdda015c802d642978f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7923769ae6e5a774a46f3800a962385b816a422913bdda015c802d642978f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf44a8f93c0627bb55864aedb3aeeebc9d52ef1947128a9d293e0769187cdf4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a49019a1bdeeb055f7f85eb43f20c4947ee5baf742f97e22687fc28a2556003"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
