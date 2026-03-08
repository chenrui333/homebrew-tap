class Climp < Formula
  desc "CLI media player"
  homepage "https://climp.net"
  url "https://github.com/olivier-w/climp/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "92b30ab8aff15240f1d859cc2667d380d7b58642990023875fafae2b111b91c8"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aeb71c249c21df9aef4865f1ad21744fda67335ea685e47aedc35693997de8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f00338c26baa5797abead1726a46846e9c1928504062dc6b1aee7cb096cf944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c142f344299a0d1089f2f7ef6069190ff4e2be96de84ee37f6429132ee915f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed122419b387d6f08293425f0bdef0e50539f87b6c1916f61344ac776feea8a4"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/climp --version")

    (testpath/"sample.txt").write("not audio\n")
    output = shell_output("#{bin}/climp #{testpath}/sample.txt 2>&1", 1)
    assert_match "unsupported format .txt", output
  end
end
