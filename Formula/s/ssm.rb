class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.0.0.tar.gz"
  sha256 "3e335523da7d9982cca82f5638afda50d25332e31af08bbe5320494b572e72a2"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f16c4ab1d92af4df41b71a0ee58ebe054373664f4ef82bafd819dd5721333aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16c4ab1d92af4df41b71a0ee58ebe054373664f4ef82bafd819dd5721333aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f16c4ab1d92af4df41b71a0ee58ebe054373664f4ef82bafd819dd5721333aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8503fc15fcb34c5a16f7d2841f722efdbba42ad42d93c1ecbc4db104c411d9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84bc9bfc82612ceb497492ca2bbb831e2f76077913898ff67ad5ac9f2eb66ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end
