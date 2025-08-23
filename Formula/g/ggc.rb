class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/3.2.1.tar.gz"
  sha256 "93f0f3f74c90fcb52ae222956a6c454c70b39abf0b6ef1b95337541c271ab8ef"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f6156f185d75df9e12ed6a6d04d98595f9e6fc968f9de10d56a5f0294d8403a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d02272cbb983a7d7b218c89cae3bbcd2af86c38acdfb3b2882df5b67715f977"
    sha256 cellar: :any_skip_relocation, ventura:       "f3bb9144c0ecd0b7c09ccc66e735bff93b895a5bc950b373d71a1a93a417b321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c26da81e781f93f0ecff0cb0204d424320fea1658ecbda734c3a78cdcefc5ab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
