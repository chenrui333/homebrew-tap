# framework: clap
class Omekasy < Formula
  desc "Converts alphanumeric input to various Unicode styles"
  homepage "https://github.com/ikanago/omekasy"
  url "https://github.com/ikanago/omekasy/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "0def519ad64396aa12b341dee459049fb54a3cfae265ae739da5e65ca1d7e377"
  license "MIT"
  head "https://github.com/ikanago/omekasy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8d34eacd65dc531dfc58ec0873e17ec6962a08726be6422993f6e5b27d0d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd58d426e7458420d7c2a288203b97b574bb4402fa97fd0dd6e35fefc62e7258"
    sha256 cellar: :any_skip_relocation, ventura:       "6108e9fd574e1ad16cc863893929521a6dacc2c4a5757366d2b9648353691275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0b70ab5e913e1a806c4fd116267589b32d2ecfb07293dc233c44ee37d860c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omekasy --version")
    output = shell_output("#{bin}/omekasy -f monospace Hello")
    assert_match "𝙷𝚎𝚕𝚕𝚘", output
  end
end
