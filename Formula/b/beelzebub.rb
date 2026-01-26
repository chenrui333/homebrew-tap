class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "2dfd5f3e091b199817c93b9d7d51a225bc993c3ced4e2bb3b14420957d45d282"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53d8621ea941a367597135adbaa9de686f45f0d3117bfffa944b9f85ea98bcf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2452105c3029971ce7fdba0b2f1ee255b09307f79133bbf2d375540d98858d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5598a3010a3174a3a7bd674a6167217795679fb18d4f4521a3f112079aa2339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5fee2a0063bec7d40a4e9c9fa21b2619e605cfe820fc43a6b7476f49291d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02e8aaf39b7bd9e1bf77c8517b4a7e7a07b7c2cba37fb64ca02abdfbbcdfb0c"
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
