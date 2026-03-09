class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "5dd4eb8cba46e2e5f7ddd23576e0adb3ab60b676a15011a13b60690e2441edab"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36118cce42b2a8711bb248526250b0efe489e68533ea6107d7817825091ffd98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686313e0313593154e3b779369d503138b059e440076f9092651a2dbb026e4e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1890fa15b27324049ab43fe3aa6e7cc821f7f3e2eb02e39ef03d473ae8067244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "876638b91003ce7c3c44a0e97c930ee52994640a15db58e78dd8f1cdb8365621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae2e0a790c773d3ea880951a289c7a5f265e3608c67f71bf831876ec339404f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/beelzebub 2>&1", 1)
    assert_match "Error during ReadConfigurationsCore", output
  end
end
