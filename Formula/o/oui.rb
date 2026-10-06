class Oui < Formula
  desc "MAC Address CLI Toolkit"
  homepage "https://oui.is/"
  url "https://github.com/thatmattlove/oui/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6c63611297b9d24356433dcde989e4904196bad390c35e5c7846d063ec451f6b"
  license "BSD-3-Clause-Clear"
  head "https://github.com/thatmattlove/oui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e6a8c6b7266993ce0a9ec9561f502409542f60b0172e89a84750ea6359a520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e6a8c6b7266993ce0a9ec9561f502409542f60b0172e89a84750ea6359a520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "440c34a07ad91fb2cda3afdd5eb76cebec242c3d0153c8e2616cd7b74f4c9b79"
    sha256 cellar: :any,                 x86_64_linux:  "782ddae9163864a57b4827ba46ac69309ee0004c99572cf0cb7fe2a1fd117650"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oui --version")
    output = shell_output("#{bin}/oui convert F4:BD:9E:01:23:45")
    assert_match "{244,189,158,1,35,69}", output
  end
end
