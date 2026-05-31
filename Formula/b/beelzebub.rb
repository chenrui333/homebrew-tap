class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "af6197b83dff1d475a8e0bc5b4d94e8e43282ea37578b7faa24a0a414cc3ddc4"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a48741ebe94ad238c9f065125254e636b02de3deb72ea579c917896b5998c56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a5f4ba60a82a64bfd381751d1971559e410f8e42ce4ed73fc407cec4cb4276e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f8dfa59b398765844ef8f5ff4a201dbb07f41d3b6c562cfc7f262489045265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "994a79b1a14ee327571cb1d7f4763f3cd31b0befe36a356b4216110b5f9d8d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2d7fddba099e36651ca81e429853ec9022ad68a93bed7c029568e74da802b4"
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
