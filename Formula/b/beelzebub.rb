class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "ae1b1c5b336715dbd995d2124f445954dfd43e505f2e2c3895ca30b203892465"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "141e35abc98ac108418591052f490c171472e752fa0ff5800f14231e9039da71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a2e4e46cb973f1e010cca446bff034ae0ebb54f65d53e848475de61d0653d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb6d45dd3efcd6ec7ef3ce238b350580e25d46379f5d0918498cdb193bd83a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b815675d63a5ff1ae8ca0cabd570b52c8538ad24a05630b4c7d3decc5da09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ee0a4d93843c62ae3466fd40d2b92252902f27e4843260533a64f23e2f2e8e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} validate 2>&1")
    assert_match "All configurations are valid.", output
  end
end
