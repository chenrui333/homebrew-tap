# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c48b934d95e1b6006ddac422a689e2d67d8bd81f2b47a4d75389483ad3644520"
  license "MIT"
  head "https://github.com/TheYahya/enola.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27663b53671a37eef8fdaa75d859a2833fe236afd02e9bcddffe70cc8cfbe96f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27663b53671a37eef8fdaa75d859a2833fe236afd02e9bcddffe70cc8cfbe96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27663b53671a37eef8fdaa75d859a2833fe236afd02e9bcddffe70cc8cfbe96f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa880e5628fd7da963bdef79f081b9a4d7a2ec4d71f95b998c19fc8615d75c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0688efec3d683cb5e82da5745e2b71914da3927b2daf5ca99aed0d96c3ea5404"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    output = shell_output("#{bin}/enola --help")
    assert_match "A command-line tool to find username on websites", output
    assert_match "--site", output
  end
end
