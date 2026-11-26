class Csvi < Formula
  desc "Cross-platform terminal CSV editor"
  homepage "https://hymkor.github.io/csvi/"
  url "https://github.com/hymkor/csvi/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "3c127786eed17eb861173af55dba0f32b16a7bf476e15e57cc021bc2ef2e04ba"
  license "MIT"
  head "https://github.com/hymkor/csvi.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "011d7394cb7152fd7187c34cf1d1b5ed2a87c6fadbe2731c7df43d315868d698"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70995ad853fab6225666c0178a289b80ca46a85ea99fd888dd508faf35ec8f55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70995ad853fab6225666c0178a289b80ca46a85ea99fd888dd508faf35ec8f55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682e7880e6cdb169cee1a93693326a7449b4c712eadfd0dd1f62b2f8b91d0790"
    sha256 cellar: :any,                 x86_64_linux:  "4f491b7c7d7770e876922696f1beec701ddb456e1aefebc264decdcd7fd4600e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/csvi"
  end

  test do
    input = <<~CSV
      name,score
      ann,1
    CSV

    assert_match version.to_s, shell_output("#{bin}/csvi -version 2>&1")

    output = pipe_output("#{bin}/csvi -auto 'w|-|q|y' 2>/dev/null", input, 0)
    assert_equal input, output.gsub("\r\n", "\n")
  end
end
