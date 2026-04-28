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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "520e9d2db115aa858fb4f32eb5e432b4c04d0f139c010df41ed4e2dab2bea70e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c52d051161b9a87e3abbd20dac17fb0e38f812d47f36b2c98e3c613203693ad4"
    sha256 cellar: :any_skip_relocation, ventura:       "b24f0c09642e5c1f1b7b273dded09da20d20509b4196361f0342c3c8920f7490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb410d9f1e825c1784c78f3d580cf486b2780e8c5e67b2eed84cf9418b5dfa81"
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
