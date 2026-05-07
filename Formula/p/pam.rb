class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.4.2-beta.tar.gz"
  sha256 "2cfcd962db5d233813fa6888212ef4276dc9999872c358bcaa4d54f3540f2535"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c6b10d8de225ab2d1857ded340ad7931948bf978e92e08816a791582384d504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e61820552b3f38d09cdd9eedbb9ed91378fb3a0417f1e8cc18cfeac6fb795d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d788f40c889bcc1ea2b08b2fc4cd2c0b5434200b80432f934fad2771e1d63b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e5426cc48cd1334eab80fec05f2d3f202812721196759febb096fc09b5a57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72b26b7e1158a49f86ded7e6b02d7678ce06b81dd595a5a642cdaf4b04d9ff7"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    system "go", "build", *std_go_args(output: bin/"squix", ldflags: "-s -w"), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
