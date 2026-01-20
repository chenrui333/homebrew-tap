class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "1179c3d3910399aa096c4531e65bb99acf020698ae44927b1fbccea9f5167c81"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ff358802e52ea75e4351c186c52c7671cccc38c2cefbecba05582a6284967a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ff358802e52ea75e4351c186c52c7671cccc38c2cefbecba05582a6284967a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ff358802e52ea75e4351c186c52c7671cccc38c2cefbecba05582a6284967a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c77aa5c0ee25abeac5364fefb916a91bb76ad58bbba92d8bc08247fc91d0f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0582fd897a5416e85cb992e3d984c6cc63b24a8e71a827b292012adc084d9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    assert_match "Claude Code", shell_output("#{bin}/aic claude")
  end
end
