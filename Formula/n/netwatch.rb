class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "9499c109dfb148ed5da79a9c0c6c5bc83672e7e7362af18efc31456c98528fed"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5f19357c885689619c190bbb38588a41bb554da452361f1e0c4d215eedcec42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b138ae3dcb493cfaa0f20266abc4bb4370bdb2ff79ed69bb017a3b56e8f8569"
    sha256 cellar: :any,                 arm64_linux:   "f8e5bf375c75e2a4320ec979dac974aefdc035adbd85f3ecd8cfa99556cc3ec1"
    sha256 cellar: :any,                 x86_64_linux:  "6bd7fb1581bd0615110d0364465a0c7c149442601efefa5baf455619a9e34c4d"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
