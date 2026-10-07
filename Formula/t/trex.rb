class Trex < Formula
  desc "Terminal app for writing, visualizing, and testing regular expressions"
  homepage "https://github.com/samyakbardiya/trex"
  url "https://github.com/samyakbardiya/trex/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "61fec158ef869917c1758b5e35e1ca513139df64cedcd33c0db1eb286ec66e42"
  license "MIT"
  head "https://github.com/samyakbardiya/trex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b26dfc168a82a7d3eec7e97003aa6d4ebabd1cfde52671f1ad9f4d0188c9a97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab22229061b6710c70a434ec0d6f394b3f549155f8b7e2516766d60b8c3050c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607449ef99d6afb5bf939b95c870fba3c66f48e4f90713e771f9757c8eb15af2"
    sha256 cellar: :any,                 x86_64_linux:  "7883d537bf5349f23efe0dc3cf1b68f33c0ef037543e6e9aaf58648b0b852919"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/samyakbardiya/trex/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "trex version v#{version}", shell_output("#{bin}/trex --version")

    fixtures = testpath/"fixtures"
    fixtures.mkpath

    output = shell_output("#{bin}/trex #{fixtures} 2>&1", 1)
    assert_match "path is a directory, not a file:", output
    assert_match fixtures.to_s, output
  end
end
