class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "b68ceddabe1757f45b8d1275103f3d8f2abe9e54d3a2928f485fabb2e07469ff"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92c893f57835e7789995ed64d6e5d78a25984343920f6e19697aa0d3d4f57a1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a4d9f69e2f71265ab4eba10a93c92296b826704b1616488dd66138eb0e0978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a246f5d2cd12e52ee2c4f858c0ca6bd1e343ad279d8561a15055cbbefe28738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72646b4072d31717a10945306786c37f02745f6b6df3bdbef43989009b1c6636"
    sha256 cellar: :any,                 x86_64_linux:  "56727ab951cb930663a3a800b276627f275298c53ca1f3261c7b342bb77edaac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} validate 2>&1")
    assert_match "0 errors, 0 warnings", output
  end
end
