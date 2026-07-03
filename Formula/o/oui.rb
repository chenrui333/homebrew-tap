class Oui < Formula
  desc "MAC Address CLI Toolkit"
  homepage "https://oui.is/"
  url "https://github.com/thatmattlove/oui/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6c63611297b9d24356433dcde989e4904196bad390c35e5c7846d063ec451f6b"
  license "BSD-3-Clause-Clear"
  head "https://github.com/thatmattlove/oui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba73b6e056649c3119564973b4c22f234fd7a76c02578e4dd0c6b133c237ab2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba73b6e056649c3119564973b4c22f234fd7a76c02578e4dd0c6b133c237ab2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba73b6e056649c3119564973b4c22f234fd7a76c02578e4dd0c6b133c237ab2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4a8142efc7874b155167ccdfd4599b933f115fd4812ba19b3284c361317414"
    sha256 cellar: :any,                 x86_64_linux:  "cfa2dfc2ac3442400b7145653cdcccbad2cc15eaf57fcfcb45d27ec0b24e98f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oui --version")
    output = shell_output("#{bin}/oui convert F4:BD:9E:01:23:45")
    assert_match "{244,189,158,1,35,69}", output
  end
end
